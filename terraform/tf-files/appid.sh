#!/usr/bin/env bash
echo 'Beginning App ID config...'

echo 'Retrieving IAM Token...'
IAM_TOKEN=$(curl -X POST \
  'https://iam.ng.bluemix.net/oidc/token?grant_type=urn:ibm:params:oauth:grant-type:apikey&apikey='"$APIKEY"'' \
  -H 'Accept: application/json' \
  -H 'Content-Type: application/x-www-form-urlencoded' | jq -r '.access_token')

echo 'Sending Redirect URIs...'
curl -X PUT \
  https://appid-management.ng.bluemix.net/management/v4/${TENANT}/config/redirect_uris \
  -H 'Authorization: Bearer '"$IAM_TOKEN"'' \
  -H 'Content-Type: application/json' \
  -d '{
  "redirectUris": [
    "'"$DOMAIN"'"
  ]
}'

echo 'Adding User to App ID...'
curl -X POST \
  https://appid-management.ng.bluemix.net/management/v4/${TENANT}/cloud_directory/Users \
  -H 'Authorization: Bearer '"$IAM_TOKEN"'' \
  -H 'Content-Type: application/json' \
  -d '{
  "emails": [
    {
      "value": "'"$EMAIL"'",
      "primary": true
    }
  ],
  "password": "'"$PASSWORD"'",
  "name": {
    "givenName": "'"$FIRST"'",
    "familyName": "'"$LAST"'"
  }
}'

echo 'Configuration complete.'
