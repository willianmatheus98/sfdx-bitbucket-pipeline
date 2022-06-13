# Salesforce Bitbucket Pipelines CI/CD

# **How does it work?**

The deployment automation is done by the pipelines of the Bitbucket and this is configured on the file `bitbucket-pipelines.yml`, in this file you can add any bash commands that you want, for our deployment we can resume the steps like below

- Permissions and additional installations
    - Python and libs (necessary to identify some file names)
    - SFDX plugin delta (identify the changes of salesforce metadata E.g. Apex classes, Custom fields, Triggers, etc.)
    - PMD (Static code analyzer)
- SFDX Authentication by JWT
- SFDX plugin delta
    - Identify changed files that can be deployed and build the `package.xml`
    - If validation
        - `-to HEAD --from origin/[destination branch]`(compare all the commits to the destination branch)
    - If deployment
        - `-to HEAD --from HEAD^`  (compare each commit with the previous)
- PMD on the Apex classes that changed
- Identify test classes
    - Check each apex class changed and try to find the respective test class with the suffix **“_Test”**
- Validation (SFDX)
    - Changes in classes?
        - If yes
            - Run deployment validation with specified tests
        - If no
            - Run deployment validation without any tests
    - Nothing changed in the folder `force-app`
- Deploy (SFDX)
    - Changes in classes?
        - If yes
            - Run real deployment with specified tests
        - If no
            - Run real deployment without any tests
    - Nothing changed in the folder `force-app`
        - It will not deploy any SFDC metadata

If you want to skip the pipeline automation, add a **[skip ci]** inside the commit message