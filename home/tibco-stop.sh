#!/bin/bash

kill $(ps aux | grep '[b]wagent' | awk '{print $2}')
sleep 5
kill $(ps aux | grep '[t]ibftlserver' | awk '{print $2}')
sleep 5
kill $(ps aux | grep '[t]ea' | awk '{print $2}')


