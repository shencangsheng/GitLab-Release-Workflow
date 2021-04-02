
# alpine-gitlab-ci-changelog
## 如何使用
1. 编译镜像 `bash deployment.sh`
2. 在项目中创建访问令牌需要api、push代码权限
3. 将访问令牌存入CI/CD环境变量中`Access_Token:令牌`
4. 将如下代码加入到CI里
```` 
image: gitlab/bash:latest
script:
     - git tag > tags.txt
     - before_tag=`cat tags.txt | grep -B 1 $CI_COMMIT_TAG | head -n 1`
     - bash /changelog.sh $before_tag
     - bash /release.sh
     - git config user.name "${GITLAB_USER_NAME}"
     - git config user.email "${GITLAB_USER_EMAIL}"
     - git add CHANGELOG.md
     - sed -i "s/gitlab-ci-token:${CI_BUILD_TOKEN}/${GITLAB_USER_NAME}:${Access_Token}/g" .git/config
     - git commit -m "create chengelog"
     - git push -f origin HEAD:$CI_COMMIT_TAG