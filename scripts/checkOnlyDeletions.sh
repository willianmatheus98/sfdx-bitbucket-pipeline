if [ ! -d "changed-sources/force-app" ]; then
    echo "No deploy needed, only deletions"
    exit 0
fi