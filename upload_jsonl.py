#!/usr/bin/env python
# Note that this is python3 only
import argparse
import requests

parser = argparse.ArgumentParser("Upload a json-lines file to a FHIR server")
parser.add_argument("url", help="The url to which to upload")
parser.add_argument("filename", help="The file to upload (I know I should accept stdin too...)")
args = parser.parse_args()

with open(args.filename, 'r') as f:
    header = {'Content-Type': "application/fhir+json; charset=utf-8"}
    for line in f:
        requests.post(args.url, headers=header, data=line)

