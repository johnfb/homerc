#!/bin/bash
'''exec' python3 $0 "$@"
'''
# vim: ft=python
import pathlib
import datetime

def parse_schedule(text):
    r = {}
    for line in text.split('\n'):
        line = line.strip()
        if not line:
            continue
        k, v = line.split('=', 2)
        k = k.strip()
        v = v.strip()
        r[k] = v
    return r

def main():
    schedule_file = pathlib.Path('/run/systemd/shutdown/scheduled')
    if not schedule_file.exists():
        return
    sched = parse_schedule(schedule_file.read_text())
    when = datetime.datetime.fromtimestamp(float(sched['USEC'])/1e6)
    now = datetime.datetime.now()
    delta = when - now
    print(f'scheduled {sched["MODE"]} in {delta}')


if __name__ == '__main__':
    main()
