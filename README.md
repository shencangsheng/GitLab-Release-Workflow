
# Minimal using Alpine as base image, release- Changelog is generated in GitLab CI/CD

NOTE, This repo, now deprecated; all new releases for repo will be published in [shencangsheng/Git-Release-Workflow](https://github.com/shencangsheng/Git-Release-Workflow)

[ GitHub  Repositorie ](https://github.com/shencangsheng/alpine-gitlab-ci-changelog)

## How to use for your
1. Creating access tokens in a project requires API, push code permissions
2. Store the access token in the CI/CD environment variable 'Access_Token: token'
3. Add the following code to the CI ( just keep the first line if you just want to push release-note )
```` 
image: shencangsheng/gitlab-release-changelog
script:
     - bash /release.sh
     - git config user.name "${GITLAB_USER_NAME}"
     - git config user.email "${GITLAB_USER_EMAIL}"
     - git add CHANGELOG.md
     - sed -i "s/gitlab-ci-token:${CI_BUILD_TOKEN}/${GITLAB_USER_NAME}:${Access_Token}/g" .git/config
     - git commit -m "create chengelog"
     - git push -f origin HEAD:$CI_COMMIT_TAG
````
## GitLab Version For API
> ( version <= 13.x )  :  `13.x`
>
> ( version >= 14.x ) :  `14.x`
