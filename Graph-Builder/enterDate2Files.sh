#!/bin/bash
# Script um automatisch die Speedtests zu Grafiken zu machen.
year="2016"
read -p "Bitte YYYY-MM-DD eingeben:" date
echo "Es wird: "$date" verwendet! Im Jahr "$year" !"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_dir="$(dirname "${script_dir}")"

cat "${repo_dir}/speedtestausgabe-192.168.178.1.csv" | grep $date > "${script_dir}/${date}.csv"
mv "${script_dir}/${date}.csv" "${script_dir}/test.csv"
cd "${script_dir}"
python3 graph-builder.py test.csv png
mv test-download.png "${script_dir}/${date}-download.png"
mv test-upload.png "${script_dir}/${date}-upload.png"
mv test-ping.png "${script_dir}/${date}-ping.png"
mv test.csv "${script_dir}/${date}.csv"
html1="<tr><th><h2>Wochentag<br>"$date"</h2></th>"
html2='<th><a href="/'
html3=$year"/"$date"-download.png"
html4='"><img src="/'
html5=$year"/"$date"-download.png"
html6='" width="300" height="200" alt="DownloadGraphic"></a></th>'
html7='<th><a href="/'
html8=$year"/"$date"-upload.png"
html9='"><img src="/'
html10=$year"/"$date"-upload.png"
html11='" width="300" height="200" alt="UploadGraphic"></a></th>'
html12='<th><a href="/'
html13=$year"/"$date"-ping.png"
html14='"><img src="/'
html15=$year"/"$date-"ping.png"
html16='" width="300" height="200" alt="PingGraphic"></a></th>'
html17='<th><a href="/'
html18=$year"/"$date".csv"
html19='">CSV-Link</a></th></tr>'

echo $html1$html2$html3$html4$html5$html6$html7$html8$html9$html10$html11$html12$html13$html14$html15$html16$html17$html18$html19
