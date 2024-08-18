# PWSweatherUpdater

This script `update_pwsweather.sh` sends live weather data from a personal weather station (PWS) to PWSweather.com every 15 minutes.

## Prerequisites

- The utilities `curl`, `jq`, and `bc` must be installed on the system.
- Your PWS must be set up to provide live data via a local network HTTP endpoint.

## Usage

Configure a cron job to run this script at regular intervals.

```bash
*/15 * * * * /path/to/update_pwsweather.sh >> /var/log/pwsweather.com.log 2>&1
```

The script retrieves live weather data from the specified Ecowitt weather station, converts the data into the appropriate units for PWSweather.com, and sends the data using an HTTP request. It also logs the API call and response to a specified log file.

## Hex Codes and their Meanings

The script extracts specific weather data returned by the Ecowitt GW2000A weather station. Here are the relevant hex codes and their meanings:

- **0x02**: Outside temperature (in °C)
- **0x07**: Humidity (in %)
- **0x03**: Dew point (in °C)
- **0x05**: Feels like temperature (in °C)
- **0x0B**: Wind speed (in m/s)
- **0x0C**: Wind gust speed (in m/s)
- **0x0D**: Rainfall (in mm)
- **0x0E**: Rain rate (in mm/h)
- **0x15**: Solar radiation (in W/m²)
- **0x19**: Wind speed (alternate, in m/s)
- **0x10**: Daily rainfall (in mm)
- **0x0A**: Wind direction (in degrees)

For more details about these codes and the structure of the weather data, refer to the Ecowitt documentation [here](https://www.ecowitt.com).

## License

This project is licensed under the MIT License.
