echo With queue $(grep -E -L "Connection timed out|Download list contain: 0" logs/*.log |grep -c ""), whithout queue $(grep -l "Download list contain: 0" logs/*.log |grep -c ""), No connection $(grep -l "Connection timed out" logs/*.log |grep -c "")