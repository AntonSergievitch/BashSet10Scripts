grep -Ili 'no route' logs/*.log | sed -e 's/.log//' -e 's/logs\///'
grep -Ili 'Connection timed out' logs/*.log | sed -e 's/.log//' -e 's/logs\///'