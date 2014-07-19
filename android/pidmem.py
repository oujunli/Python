"""
pidmem.py  - Pid Memory
		========================

Copyright 2014 Alibaba Inc.
   Author:   wuchen <oujunli306@gmail.com> <junli.ojl@alibaba-inc.com> Wireless Performance Team
   License:   The GNU Free Documentation License, Version 1.2
               (dual licensed under the GPL v2)
"""
import sys, os, re, datetime, getopt, time, string

def usage():
    print('''Help Information:
             -h, --help     print this help  
             -i,--interval  repeat memory statistics on specified time interval
             Example:
             1) python pidmem.py -i 1 com.taobao.taobao
             2) python pidmem.py -i 1 PID
                                    ''')

def head(cmd):
    i = 0
    out = os.popen(cmd).read().split('\n')
    for line in out:
        if line.find('Memory Usage')>0:
            print('\n%s'%(line))
        elif line.find('MEMINFO in pid')>0:
            print('%s'%(line))
            i+=1
        elif i>0 and i<4:
            print('%s'%(line))
            i+=1
        elif i==4:
            break
        else:
            continue

def main(argv):
	try:
		opts, args = getopt.getopt(argv,"hi:",["help"])
	except getopt.GetoptError:
			usage()
			sys.exit(2)
	for opt, arg in opts:
		if opt in ("-h", "--help"):
			usage()
			sys.exit()
		if opt in ("-i"):
			interval = string.atoi(arg)
        
        if args:
            cmd = 'adb shell dumpsys meminfo %s' %(args[0])
        else:
            usage()
            sys.exit()
       
        print('Profiling... Hit Ctrl-C to end')
        head(cmd)

        try:
            while 1:
                out = os.popen(cmd).read().split('\n')
                for line in out:
                    if line.find('TOTAL') > 0:
                        print('%s'%(line))
                        break
                time.sleep(interval)
        except KeyboardInterrupt:
            print('\nUser Press Ctrl+C,Exit')
        except EOFError:
            print('\nUser Press Ctrl+D,Exit')
        
if __name__ == "__main__":
    main(sys.argv[1:])
