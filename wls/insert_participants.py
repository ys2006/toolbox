#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys
import datetime
import cx_Oracle
import random
import traceback
import string
import uuid
import os
import re
import getopt
import time as systime

INITPOOLMAXUSER = 20000
DOFISSSION_HITO_NUM = 500
FISSION_PER_HITO = 10
EVENTID = 25
ACTIVITY_TYPE = "scan"
ASSET = "NULL"
ts = datetime.datetime.now()
connection = cx_Oracle.connect(
    "xx", "xxx", "xxx.com:1521/test")
tblIdx = 6000  # start insert index

invitorDict = {}
inviteeDict = {}


def main(argv):

    initPersonPool()
    result = doFission("dylan")
    doFissionCount = 1
    while doFissionCount < DOFISSSION_HITO_NUM and result != -1:
        popName = inviteeDict.pop(random.choice(inviteeDict.keys()))
        result = doFission(popName)

    connection.close()


def initPersonPool():
    nameIdx = 1
    while nameIdx <= INITPOOLMAXUSER:
        inviteeName = "user" + str(nameIdx)
        invitorDict.update({nameIdx: inviteeName})
        nameIdx = nameIdx + 1
    print ("invitors are:", invitorDict)


def doFission(invName):

    global tblIdx, inviteeDict
    print("DoFission Start")
    print("tblIdx is:", tblIdx)
    pickNum = 1
    M = []
    print ("invitors are:", invName)
    print ("invitees are:")
    while pickNum <= FISSION_PER_HITO:
        if not invitorDict:
            print("Pool is drilled. Stop the fission")
            return -1
        else:
            popName = invitorDict.pop(random.choice(list(invitorDict.keys())))
            print (pickNum, ":", popName)
            inviteeDict.update({tblIdx: popName})
            pickNum = pickNum + 1
            M.append((tblIdx, EVENTID, popName,
                      invName, ACTIVITY_TYPE, ASSET, ts))
            tblIdx += 1
    print ("after poped, people pool are:", invitorDict)

    cursor = connection.cursor()
    try:
        cursor.executemany("""
        INSERT INTO gcschema_1967321140.participant_relationship(id, event_id, participant1, participant2, activity_type, asset, create_date) VALUES(:1, :2, :3, :4, :5, :6, :7)""", M)
        connection.commit()
    except cx_Oracle.DatabaseError as e:
        errorObj, = e.args
        connection.rollback()
        print("Row", "has error", errorObj.message)

    print("DoFission End")
    return 0


if __name__ == "__main__":
    main(sys.argv[1:])
