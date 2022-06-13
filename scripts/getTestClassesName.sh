xq . < package/package.xml > package_json
cat package_json
# Will search for classes with suffix _Test
xq . < package/package.xml | jq -r '.Package.types | if type=="array" then .[] else . end | select(.name=="ApexClass") | .members | if type!="array" then . + "_Test,"   else join("_Test,") | . + "_Test" end' > TEST_CLASSES
echo '-- TEST CLASS TO RUN ---'
echo 'TEST_CLASSES BF'
cat TEST_CLASSES
echo 'TEST_CLASSES AF'
tr '\n' , < TEST_CLASSES > TEST_CLASSES_MERGED
cat TEST_CLASSES_MERGED