echo 'Create IAM Token with API Key'
# NOTE: THIS NEEDS API KEY
IAM_TOKEN=$(curl -X POST \
  'https://iam.ng.bluemix.net/oidc/token?grant_type=urn:ibm:params:oauth:grant-type:apikey&apikey='"$APIKEY"'' \
  -H 'Accept: application/json' \
  -H 'Content-Type: application/x-www-form-urlencoded' | jq -r '.access_token')

# This will create a root key with name root key
# Add payload to have BYOK
# Otherwise, root key will be created for you
ROOT_KEY=$(curl -X POST \
  https://${REGION}.kms.cloud.ibm.com/api/v2/keys \
  -H 'authorization: Bearer ${IAM_TOKEN}' \
  -H 'bluemix-instance: ${KEYPROTECT}' \
  -H 'content-type: application/vnd.ibm.kms.key+json' \
  -d '
  {
    "metadata":
    {
      "collectionType": "application/vnd.ibm.kms.key+json",
      "collectionTotal": 1
    },
    "resources":
    [
      {
        "type": "application/vnd.ibm.kms.key+json",
        "name": "${KEY_NAME}",
        "description": "${KEY_DESCRIPTION}",
        "extractable": false,
        "payload": "${KEY_PAYLOAD}"
      }
    ]
  }')

ibmcloud ks key-protect-enable --cluster $CLUSTER --key-protect-url $REGION.kms.cloud.ibm.com --key-protect-instance $KEYPROTECT --crk $ROOT_KEY
