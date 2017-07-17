#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys,os,re
import getopt
import time as systime
import traceback
import string
import urllib2
import lxml.html
#import requests
import wget

def main(argv):
    try:
        opts, args = getopt.getopt(argv, "hu:r:", ["help", "url=", "repo="])
    except getopt.GetoptError:
        usage()
        sys.exit(2)
    print opts
    for opt, arg in opts:
        if opt == '-h':
            print 'getAll.py -u <url> -r <repository>'
            sys.exit()
        elif opt in ("-u", "--url"):
            url = arg
        elif opt in ("-r", "--repo"):
            repo = arg
    currentDir =  os.path.split(os.path.abspath(sys.argv[0]))[0]
    outputD = currentDir + '/' + repo
    print '-------------------'
    print outputD
    print '-------------------'
    if not os.path.isdir(outputD):
        os.mkdir(outputD)
    html = urllib2.urlopen(url).read()
    root = lxml.html.fromstring(html)
    anchors = root.xpath('//a')
    for anchor in anchors:
        if re.search('.rpm', anchor.text, re.M|re.I):
            print anchor.text
            urlStr = url + '/' + 'getPackage' + '/' + anchor.text
            #outputF = currentDir + '/' + repo + '/' + anchor.text
            wget.download(urlStr, out=outputD)
            #r = requests.get(urlStr)
            #open(outputF, 'wb').write(r.content)
if __name__ == "__main__":
    main(sys.argv[1:])
