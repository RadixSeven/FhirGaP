#!/usr/bin/env python
# Note that this is python3 only
import argparse
import requests
from tqdm import tqdm

parser = argparse.ArgumentParser("Upload a json-lines file to a FHIR server")
parser.add_argument("url", help="The url to which to upload")
parser.add_argument("filename", help="The file to upload (I know I should accept stdin too...)")
parser.add_argument("--auth", default="Bearer Admin", help="The authorization string to use")
args = parser.parse_args()

with open(args.filename, 'r') as f:
    header = {
        'Content-Type': "application/fhir+json; charset=utf-8",
        'Authorization': args.auth,
    }
    for line in tqdm(f):
        requests.post(args.url, headers=header, data=line)

