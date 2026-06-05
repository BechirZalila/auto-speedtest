# Auto-Speedtest

A lightweight, automated utility to periodically measure and log internet connection performance (ping latency, download, and upload speeds) and generate custom charts.

## Features
* **Automated Speed Tests**: Run network speed checks periodically (via `cron`) and log to CSV files.
* **Offline Fallbacks**: Gracefully handles network loss by logging fallback values (e.g., `999.0` ping, `0.0` speeds) instead of crashing.
* **Visualization**: Generate PNG/PDF line charts (Ping, Download, Upload) using `matplotlib`.
* **Hardware Display Support**: Print current network speeds directly to a 20x4 character LCD screen connected to a Raspberry Pi.
* **Backup**: Package logs and charts into compressed archives and transfer them via SCP to a backup server.
* **Dynamic Paths**: Relocatable scripts that resolve paths relative to their directory.

---

## File Structure
* [speedtest.sh](file:///home/zalila/devel/git/auto-speedtest/speedtest.sh): Core script executing speed tests and writing results to CSV logs.
* [Graph-Builder/graph-builder.py](file:///home/zalila/devel/git/auto-speedtest/Graph-Builder/graph-builder.py): Python module to parse logs and render matplotlib graphs.
* [display.py](file:///home/zalila/devel/git/auto-speedtest/display.py): Character LCD interface driver.
* [backup.sh](file:///home/zalila/devel/git/auto-speedtest/backup.sh): Archive and remote backup script.
* [generator.sh](file:///home/zalila/devel/git/auto-speedtest/generator.sh) / [Graph-Builder/enterDate2Files.sh](file:///home/zalila/devel/git/auto-speedtest/Graph-Builder/enterDate2Files.sh): Daily log filtering and plot generation utilities.
* [installAuto-Speedtest.sh](file:///home/zalila/devel/git/auto-speedtest/installAuto-Speedtest.sh): Automates dependency checking and installation setup.

---

## Installation & Setup

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/Wlanfr3ak/auto-speedtest.git
   cd auto-speedtest
   ```

2. **Run the Installer**:
   ```bash
   ./installAuto-Speedtest.sh
   ```
   *This checks for Python 3 dependencies, downloads `speedtest-cli` locally if not present, and configures file permissions.*

3. **Install Graph Building Dependencies (Optional)**:
   On Ubuntu/Debian:
   ```bash
   sudo apt-get install python3 python3-matplotlib python3-numpy
   ```

4. **Automate with Crontab**:
   Open your user's crontab using:
   ```bash
   crontab -e
   ```
   Add a line to run the test periodically (e.g., every 5 minutes):
   ```text
   */5 * * * * /absolute/path/to/auto-speedtest/speedtest.sh > /dev/null 2>&1
   ```

---

## Log Output Format
Speed test entries are saved in daily CSV files (named `<hostname>-YYYY-MM-DD.csv`) with the following format:
```text
YEAR-MONTH-DAY;HOUR:MINUTE:SECOND;PING;DOWNLOAD;UPLOAD
```
* **PING**: Latency in milliseconds.
* **DOWNLOAD**: Speed in Mbit/s.
* **UPLOAD**: Speed in Mbit/s.

---

## Manual Graph Rendering
To manually build graphs from your CSV file for a specific date:
```bash
./generator.sh
```
Follow the prompt to enter the date (`YYYY-MM-DD`). The script will generate the corresponding download, upload, and ping charts.

---

## License
This project is licensed under the [WTFPL](file:///home/zalila/devel/git/auto-speedtest/LICENSE) (Do What The Fuck You Want To Public License).
