#!/usr/bin/python
"""
Use like this:

ldd /usr/bin/redis-server | python find_packages.py
"""

import sys
import os
import re


path_re = re.compile(' ((?:/[^/]+)+) ')


def read(command):
    popen = os.popen(command)
    data = popen.read()
    retcode = popen.close()
    if retcode:
        if data:
            sys.stderr.write(data.strip() + '\n')
        sys.exit('Failed (%s) to run %r' % (retcode, command))
    return data.strip()


seen_path = set()
seen_package = set()


for line in sys.stdin:
    for path in path_re.findall(line):
        if path in seen_path:
            continue
        seen_path.add(path)
        print '==>', path
        data = read('apt-file search %s' % path)
        for item in data.split('\n'):
            print item
            name = item.split(':')[0]
            if name in seen_package:
                continue
            seen_package.add(name)
            os.system('apt-cache show %s | grep -i ^Version' % name)
            print
        print
