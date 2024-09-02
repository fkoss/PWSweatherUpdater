#!/bin/bash
#
# update_pwsweather.sh - Script to send live weather data from a personal weather station (PWS)
#                        to PWSweather.com every 15 minutes.
#
# This script retrieves live weather data from a specified Ecowitt weather station via HTTP,
# converts the data into the appropriate units for PWSweather.com, and sends the data using
# an HTTP request. The script also logs the API call and the response from PWSweather.com
# to a specified log file.
#
# Prerequisites:
# - The 'curl', 'jq', and 'bc' utilities must be installed on the system.
# - Your PWS must be set up to provide live data via a local network HTTP endpoint.
#
# Usage:
# - Configure the cron job to run this script every 15 minutes:
#   */15  * * * * /path/to/update_pwsweather.sh >> /var/log/pwsweather.com.log 2>&1
#
# Variables:
# - STATION_ID:     Your PWSweather.com station ID.
# - API_KEY:        Your PWSweather.com API key.
# - WEATHER_STATION_IP: Local IP address of your weather station.
# - LOGFILE:        Path to the log file where API call and response will be recorded.
#
# Author: ChatGPT (OpenAI)
# Composer: Frank Koss
# Version: 1.0.1
# License: MIT
# Date: August 2024
# Last change: September 2024
#


# Station Information
STATION_ID="INSERT_YOUR_STATION_ID_HERE"
API_KEY="INSERT_YOUR_API_KEY_HERE"

# Weather Station IP address
WEATHER_STATION_IP="INSERT_YOUR_STATION_IP_HERE"

# Logfile
LOGFILE="/var/log/pwsweather.com.log"

# Request local live weather data from our pws
response=$(curl -s "http://$WEATHER_STATION_IP/get_livedata_info?")

# Extract values by ID
temp_c=$(echo $response | jq -r '.common_list[] | select(.id=="0x02").val')
humidity=$(echo $response | jq -r '.common_list[] | select(.id=="0x07").val' | tr -d '%')
dewpoint_c=$(echo $response | jq -r '.common_list[] | select(.id=="0x03").val')
wind_speed_kmh=$(echo $response | jq -r '.common_list[] | select(.id=="0x0B").val' | awk '{print $1}')
wind_gust_kmh=$(echo $response | jq -r '.common_list[] | select(.id=="0x0C").val' | awk '{print $1}')
wind_dir=$(echo $response | jq -r '.common_list[] | select(.id=="0x0A").val')
pressure_hpa=$(echo $response | jq -r '.wh25[0].rel' | awk '{print $1}')
rainin_mm=$(echo $response | jq -r '.rain[] | select(.id=="0x0D").val' | awk '{print $1}')
dailyrainin_mm=$(echo $response | jq -r '.rain[] | select(.id=="0x10").val' | awk '{print $1}')

# Translate units from metric to imperial
temp_f=$(echo "scale=2; $temp_c * 9 / 5 + 32" | bc)
pressure_inhg=$(echo "scale=2; $pressure_hpa * 0.02953" | bc)
wind_speed_mph=$(echo "scale=2; $wind_speed_kmh * 0.621371" | bc)
windgustmph=$(echo "scale=2; $wind_gust_kmh * 0.621371" | bc)
rainin=$(echo "scale=2; $rainin_mm * 0.0393701" | bc)
dailyrainin=$(echo "scale=2; $dailyrainin_mm * 0.0393701" | bc)
dewptf=$(echo "scale=2; $dewpoint_c * 9 / 5 + 32" | bc)

# API-URL creation
api_call="https://www.pwsweather.com/pwsupdate/pwsupdate.php?ID=$STATION_ID&PASSWORD=$API_KEY&dateutc=now&tempf=$temp_f&humidity=$humidity&baromin=$pressure_inhg&dewptf=$dewptf&rainin=$rainin&dailyrainin=$dailyrainin&winddir=$wind_dir&windspeedmph=$wind_speed_mph&windgustmph=$windgustmph&action=updateraw"

# API-Call execution and answer handling
api_response=$(curl -s "$api_call")

# Extract the response's body text
body_response=$(echo "$api_response" | awk -v RS="</?body>" 'NR==2' | tr -d '\n')

# Add log entry
echo "$(date '+%Y-%m-%d %H:%M:%S') - API Call: $api_call" >> $LOGFILE
echo "$(date '+%Y-%m-%d %H:%M:%S') - Response: $body_response" >> $LOGFILE
