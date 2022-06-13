echo "-------------------package/package.xml file---------------------"
less -FX package/package.xml
echo "\n-------------------package/package.xml file---------------------"

destination="origin/${BITBUCKET_BRANCH}"
echo "-------------------DESTINATION BRANCH IS: [$destination]---------------------"
metalistSfdx=$(git diff --name-only HEAD HEAD~1  -- force-app/main/default | tr '\n' ',' | sed 's/.$//' )
echo "-------------------METALIST: [$metalistSfdx]---------------------"
if [ ! -z "$(<TEST_CLASSES_MERGED)" ]
then
    echo "IT WILL DEPLOY WITH SPECIFIED TEST CLASSES"
    echo "-------------------TEST CLASSES: [$(<TEST_CLASSES_MERGED)]---------------------"
    sfdx force:source:deploy -x package/package.xml --targetusername sfdx-ci -l RunSpecifiedTests -r "$(<TEST_CLASSES_MERGED)" --verbose
elif [ -z "$(<TEST_CLASSES_MERGED)" ] && [ ! -z "$metalistSfdx" ] && [ "$destination" != "origin/main" ]
then
    echo "IT WILL DEPLOY WITHOUT ANY TEST (SANDBOX)"
    sfdx force:source:deploy -x package/package.xml --targetusername sfdx-ci --verbose
elif [ -z "$(<TEST_CLASSES_MERGED)" ] && [ ! -z "$metalistSfdx" ] && [ "$destination" == "origin/main" ]
then
    echo "IT WILL DEPLOY RUNNING LOCAL TESTS (PRODUCTION)"
    # In prod we need to run some test class
    sfdx force:source:deploy -x package/package.xml --targetusername sfdx-ci -l RunLocalTests --verbose
else
	echo "No SF changes found"
fi