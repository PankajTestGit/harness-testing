BASE_URL="<+pipeline.variables.BaseUrl>"
TOKEN_URL="<+pipeline.variables.TokenUrl>"

#===============Get Token========================
echo "Getting token..."
TOKEN=$(curl -X POST "$TOKEN_URL" \
-H 'Content-Type: application/x-www-form-urlencoded' \
-d 'grant_type=client_credentials&client_id=<+secrets.getValue("client_id")>&client_secret=<+secrets.getValue("client_secret")>')
  
TOKEN_VALUE=$(echo $TOKEN | jq -r '.access_token')

echo $TOKEN_VALUE

#===============Trigger deployment========================
echo "Triggering pipeline execution...<+pipeline.variables.PipelineId>"
PIPELINE_DEPLOY_URL="/<+pipeline.variables.PipelineId>/deployments"
PIPELINE_DEPLOY_BODY='{
  "description": "Pipeline triggered through Harness",
  "triggeredBy": "<+pipeline.triggeredBy.name>",
  "triggeredByOperatorName": "Harness"
}'

echo "$BASE_URL$PIPELINE_DEPLOY_URL"

curl --location --request POST "$BASE_URL$PIPELINE_DEPLOY_URL" --header "Authorization: Bearer $TOKEN_VALUE" --header 'Content-Type: text/plain' \
--data-raw "$PIPELINE_DEPLOY_BODY"
sleep 10
