chmod +x scripts/additionalInstallations.sh
chmod +x scripts/getTestClassesName.sh
chmod +x scripts/validateDeploy.sh
sfdx --version
destination="origin/${BITBUCKET_PR_DESTINATION_BRANCH}"
echo "-------------------DESTINATION BRANCH IS: [$destination]---------------------"
if [[ "$destination" == "origin/release/dev" || "$destination" == "origin/feature/dev" ]]
then
    validationEnv="DEV"
    consumerKey=$SFDC_DEV_CONSUMER_KEY
    username=$SFDC_DEV_USERNAME
    loginUrl=$SFDC_SANDBOX_INSTANCE_URL
elif [ "$destination" == "origin/release/uat" ]
then
    validationEnv="UAT"
    consumerKey=$SFDC_UAT_CONSUMER_KEY
    username=$SFDC_UAT_USERNAME
    loginUrl=$SFDC_SANDBOX_INSTANCE_URL
elif [ "$destination" == "origin/release/hotfix" ]
then
    validationEnv="HOTFIX"
    consumerKey=$SFDC_HOTFIX_CONSUMER_KEY
    username=$SFDC_HOTFIX_USERNAME
    loginUrl=$SFDC_SANDBOX_INSTANCE_URL
elif [ "$destination" == "origin/main" ]
then
    validationEnv="PROD"
    consumerKey=$SFDC_PROD_CONSUMER_KEY
    username=$SFDC_PROD_USERNAME
    loginUrl=$SFDC_PROD_INSTANCE_URL
else
    echo "branch isn't mapped yet"
    exit 0
fi
echo "-------------------VALIDATION ON ENVIRONMENT: [$validationEnv]---------------------"
metalistSF=$(git diff --name-only HEAD $destination  -- force-app/main/default | tr '\n' ',' | sed 's/.$//' )
echo $metalistSF
if [ ! -z "$metalistSF" ]
then
    unzip pmd/pmd-bin-6.42.0.zip -d pmd
    scripts/additionalInstallations.sh
    sfdx force:auth:jwt:grant --clientid $consumerKey --username $username --jwtkeyfile keys/server.key --setdefaultdevhubusername --setalias sfdx-ci --instanceurl $loginUrl
    mkdir changed-sources
    sfdx sgd:source:delta -s force-app --to HEAD --from $destination --output ./changed-sources --generate-delta
    #===Make sure there is no PMD error with a high priority===
    pmd/pmd-bin-6.42.0/bin/run.sh pmd --minimum-priority $PMD_MINIMUM_PRIORITY -d ./changed-sources -R pmd/custom-apex-rules.xml -f textcolor -l apex
    scripts/getTestClassesName.sh
    scripts/validateDeploy.sh
else 
    echo "No SF changes found"
fi