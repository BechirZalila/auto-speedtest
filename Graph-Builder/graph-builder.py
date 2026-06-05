#!/usr/bin/env python3

# Written by @muellermartin
# License: Do What the Fuck You Want to Public License (WTFPL)

import matplotlib
# Use a non-interactive backend
# Note: Needs to be called before importing pyplot!
matplotlib.use("AGG")
import matplotlib.pylab as plt
import matplotlib.dates as mdates

import numpy as np

import csv
import os
import sys
import datetime

if len(sys.argv) > 1:
    csvFile = sys.argv[1]
else:
    csvFile = 'test.csv'

if len (sys.argv) > 2:
    plot_format = sys.argv [2]
else:
    plot_format = "pdf"

if len (sys.argv) > 3:
    prefix = sys.argv [3] + "-"
else:
    prefix = os.path.splitext(csvFile)[0] + "-"

if not os.path.exists(csvFile):
	# Write error message to stderr instead of stdout
	print("File \"{}\" does not exist.".format(csvFile), file=sys.stderr)
	# Return with non-zero exit status (error)
	sys.exit(1)

if not os.path.isfile(csvFile):
	# Write error message to stderr instead of stdout
	print("File \"{}\" is no regular file.".format(csvFile), file=sys.stderr)
	# Return with non-zero exit status (error)
	sys.exit(1)

# Will be used to hold data from CSV prepared for plotting
timestamps = []
ping = []
download = []
upload = []

# Process CSV file containing the data and prepare it for plotting
with open(csvFile, "r") as f:
    reader = csv.reader(f, delimiter=";")
    for row_idx, columns in enumerate(reader, 1):
        if not columns or all(not val.strip() for val in columns):
            continue  # Skip empty rows
        if len(columns) < 5:
            print(f"Warning: line {row_idx} in \"{csvFile}\" has fewer than 5 columns. Skipping.", file=sys.stderr)
            continue
        try:
            # Create datetime object from 1st & 2nd column and add it to the list
            dt = datetime.datetime.strptime(columns[0] + columns[1], "%Y-%m-%d%H:%M:%S")
            p = float(columns[2])
            d = float(columns[3])
            u = float(columns[4])
            
            timestamps.append(dt)
            ping.append(p)
            download.append(d)
            upload.append(u)
        except (ValueError, TypeError) as e:
            print(f"Warning: line {row_idx} in \"{csvFile}\" failed to parse: {e}. Skipping.", file=sys.stderr)
            continue

if not timestamps:
    print(f"Error: No valid data points found in \"{csvFile}\". Cannot generate graphs.", file=sys.stderr)
    sys.exit(1)

#plt.style.use("fivethirtyeight")

def plot (x_list, y_list, color, out_file, x_label, y_label, title, sft=None, slt=None, sftcond=False, sltcond=False):
    fig, ax = plt.subplots()
    ax.plot(x_list, y_list, color)
    ax.xaxis.set_major_formatter(mdates.DateFormatter("%H:%M"))
    ax.xaxis.set_major_locator(mdates.AutoDateLocator())
    yticks = list (np.linspace (0.0, max(y_list)*1.05, 10))
    ax.set_yticks (yticks)
    yticks = ["{:5.2f}".format (x) for x in yticks]
    if sftcond and sft != None:
        yticks [0] = sft
    if sltcond and slt != None:
        yticks [-1] = slt
    ax.set_yticklabels (yticks)
    ax.set_title(title)
    ax.set_xlabel (x_label)
    ax.set_ylabel (y_label)
    fig.autofmt_xdate()
    plt.savefig(out_file, transparent=True)

today = '(' + str (timestamps[0])[:10] + ')'
plot (timestamps, ping, "r-", prefix + "ping." + plot_format, "Date/Heure", "Ping (ms)", "Durée de ping " + today, slt="infini", sltcond=max(ping) >= 999.0)
plot (timestamps, download, "g-", prefix + "download." + plot_format, "Date/Heure", "Down (Mbit/s)", "Vitesse de Téléchargement " + today)
plot (timestamps, upload, "b-", prefix + "upload." + plot_format, "Date/Heure", "UP (Mbit/s)", "Vitesse de Téléversement " + today)
print (datetime.datetime.today())

