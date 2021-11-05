
# alpine-gitlab-ci-changelog
## 如何使用
1. 编译镜像 `bash deployment.sh`
2. 在项目中创建访问令牌需要api、push代码权限
3. 将访问令牌存入CI/CD环境变量中`Access_Token:令牌`
4. 将如下代码加入到CI里(如果只想推送release-note就只保留第一行即可)
```` 
image: gitlab/bash:latest
script:
     - bash /release.sh
     - git config user.name "${GITLAB_USER_NAME}"
     - git config user.email "${GITLAB_USER_EMAIL}"
     - git add CHANGELOG.md
     - sed -i "s/gitlab-ci-token:${CI_BUILD_TOKEN}/${GITLAB_USER_NAME}:${Access_Token}/g" .git/config
     - git commit -m "create chengelog"
     - git push -f origin HEAD:$CI_COMMIT_TAG
````
## Gitlab Version For API
> version <= 13.x >>  `release-13.x.sh`
>
> version >= 14.x >>  `release-14.x.sh`