#!/usr/bin/env python
# Note that this is python3 only
import argparse
import requests

parser = argparse.ArgumentParser(
    "Get an observation from a FHIR server with authentication")
parser.add_argument(
    "id", help="The observation id to retrieve")
parser.add_argument(
    "auth", default="Admin",
    help="The authorization string to use. \"Bearer \" will be added to "
    "the front.")
parser.add_argument(
    "--url", default="http://35.245.174.218:8080/hapi-fhir-jpaserver/fhir/",
    help="The base url of the server")
args = parser.parse_args()

headers = {
    'Content-Type': "application/fhir+json; charset=utf-8",
    'Authorization': "Bearer " + args.auth,
}
response = requests.get(args.url + "/Observation/" + args.id, headers=headers)
print(response.json())

