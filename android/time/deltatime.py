"""
deltatime.py  - compute time between start and end string in 'adb logcat -v time' output file.  
		========================

   Author:   wuchen <oujunli306@gmail.com> Wireless Performance Team
   License:   The GNU Free Documentation License, Version 1.2
               (dual licensed under the GPL v2)
"""

import sys, os, re, datetime, getopt
r = re.compile(r'\d{2}-\d{2} \d{2}:\d{2}:\d{2}.\d{3}')
start_str = 'start'
end_str = 'end'
start_time = None
end_time = None
inputfile = None
outputfile = None

def usage():
    print('''Help Information:
             -h, --help:        Show help information
	     -s, --start 	start string
	     -e, --end 		end string
             -i, --inputfile:   input file
             -o, --outputfile:  output file 
	     ''')

def delta_time():
	global inputfile, outputfile, start_str, end_str

	input_stream = open(inputfile, 'r')
   	output_stream = open(outputfile, 'w')
	for line in input_stream:
		try:
			#print line
			index = line.find(start_str)
			if index >= 0:
				match =  r.search(line)
				if match:
					start_time = datetime.datetime.strptime(match.group(), "%m-%d %H:%M:%S.%f")
					#print 'start', start_time
					output_stream.write(line)

			index = line.find(end_str)
			if index >= 0:
				match =  r.search(line)
				if match:
					end_time = datetime.datetime.strptime(match.group(), "%m-%d %H:%M:%S.%f")
					#print 'end',end_time
					if start_time and end_time:
						delta = end_time - start_time
						start_time = None
						end_time = None
						seconds = delta.total_seconds()
						output_stream.write(line)
						print seconds
						sec_str = 'delta time: ' + str(seconds)
						output_stream.write(sec_str)
						output_stream.write('\n\n')
		except:
			output_stream.write(line)
	output_stream.close()
	input_stream.close()
def main(argv):
    global inputfile, outputfile, start_str, end_str
    inputpath = None
    outputpath = None
    try:
	    opts, args = getopt.getopt(argv,"hs:e:i:o:",["help", "start=","end=", "inputfile=", "outputfile="])
    except getopt.GetoptError:
        usage()
        sys.exit(2)
    for opt, arg in opts:
        if opt in ("-h", "--help"):
            usage()
            sys.exit()       
	if opt in ("-s", "--start"):
            start_str = arg
        if opt in ("-e", "--end"):
            end_str = arg
        if opt in ("-i", "--inputfile"):
            inputfile = arg
        if opt in ("-o", "outputfile"):
            outputfile = arg
    if inputfile == None:
        usage()
        sys.exit()
    if outputfile == None:
        outputfile = os.getcwd()+"/out.txt"
    
    delta_time()
if __name__ == "__main__":
   	 main(sys.argv[1:])
