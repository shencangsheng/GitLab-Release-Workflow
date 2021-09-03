#!/bin/bash

IFS=`echo -en "\n\b"`
echo -en $IFS

if [ -f "CHANGELOG.md" ];then
    rm -f CHANGELOG.md
fi
touch CHANGELOG.md
if [ -f "CHANGELOG.txt" ];then
    rm -f CHANGELOG.txt
fi
touch CHANGELOG.txt

tagCreateDate="# ${CI_COMMIT_TAG} ("`date "+%Y-%m-%d"`"）"

echo $tagCreateDate >> CHANGELOG.md
echo $tagCreateDate >> CHANGELOG.txt

function printFeat(){
    for i in ${!feat[@]}
    do
        printChangeLog ${feat[i]} "feat:" $i
    done
    echo >> CHANGELOG.md
    echo >> CHANGELOG.txt
}

function printFix(){
    for i in ${!fix[@]}
    do
        printChangeLog ${fix[i]} "fix:" $i
    done
    echo >> CHANGELOG.md
    echo >> CHANGELOG.txt
}

function printPerf(){
    for i in ${!perf[@]}
    do
        printChangeLog ${perf[i]} "perf:" $i
    done
    echo >> CHANGELOG.md
    echo >> CHANGELOG.txt
}

function printRefactor(){
    for i in ${!refactor[@]}
    do
        printChangeLog ${refactor[i]} "refactor:" $i
    done
    echo >> CHANGELOG.md
    echo >> CHANGELOG.txt
}

function printStyle(){
    for i in ${!style[@]}
    do
        printChangeLog ${style[i]} "style:" $i
    done
    echo >> CHANGELOG.md
    echo >> CHANGELOG.txt
}

function printOther(){
    for i in ${!other[@]}
    do
        printChangeLog ${other[i]} "other:" $i
    done
    echo >> CHANGELOG.md
    echo >> CHANGELOG.txt
}

function printChangeLog() {
    text=`expr $3 + 1`". "${1/$2/""};
    echo ${text} >> CHANGELOG.md
    echo ${text} >> CHANGELOG.txt
}

function checkLog(){
    if [[ $1 == "feat:"* ]]
    then
        feat[featIndex]=$1
        let featIndex++
    elif [[ $1 == "fix:"* ]]
    then
        fix[fixIndex]=$1
        let fixIndex++
    elif [[ $1 == "perf:"* ]]
    then
        perf[perfIndex]=$1
        let perfIndex++
    elif [[ $1 == "refactor:"* ]]
    then
        refactor[refactorIndex]=$1
        let refactorIndex++
    elif [[ $1 == "style:"* ]]
    then
        style[styleIndex]=$1
        let styleIndex++
    elif [[ $1 == "other:"* ]]
    then
        other[otherIndex]=$1
        let otherIndex++
    fi
}

function printLog(){
    if [[ $featIndex -ne 0 ]]; then
        echo "### 新增" >> CHANGELOG.md
        echo "### 新增" >> CHANGELOG.txt
        printFeat
    fi

    if [[ $fixIndex -ne 0 ]]; then
        echo "### 修复" >> CHANGELOG.md
        echo "### 修复" >> CHANGELOG.txt
        printFix
    fi

    if [[ $perfIndex -ne 0 ]]; then
        echo "### 优化" >> CHANGELOG.md
        echo "### 优化" >> CHANGELOG.txt
        printPerf
    fi

    if [[ $refactorIndex -ne 0 ]]; then
        echo "### 更改" >> CHANGELOG.md
        echo "### 更改" >> CHANGELOG.txt
        printRefactor
    fi

    if [[ $styleIndex -ne 0 ]]; then
        echo "### 样式" >> CHANGELOG.md
        echo "### 样式" >> CHANGELOG.txt
        printStyle
    fi

    if [[ $otherIndex -ne 0 ]]; then
        echo "### 其他" >> CHANGELOG.md
        echo "### 其他" >> CHANGELOG.txt
        printOther
    fi

    feat=()
    featIndex=0

    fix=()
    fixIndex=0

    other=()
    otherIndex=0

    perf=()
    perfIndex=0

    refactor=()
    refactorIndex=0

    style=()
    styleIndex=0

    other=()
    otherIndex=0
}

curDate=""
function checkDate()
{
    if [[ $curDate = $1 ]]; then
        return
    fi
    curDate=$1

    printLog

    echo >> CHANGELOG.md
    echo >> CHANGELOG.txt
    echo "## "$curDate >> CHANGELOG.md
    echo "## "$curDate >> CHANGELOG.txt
}

tags_id=""

if [ ! $1 = ${CI_COMMIT_TAG} ]; then
  tags_id="$1...${CI_COMMIT_TAG}"
fi

commitMessageList=`git log --date=format:'%Y-%m-%d' --pretty=format:'%cd%n%s(%h)' $tags_id`

index=0

for i in ${commitMessageList[@]}
do
    if [[ $index%2 -ne 0 ]]; then
        checkLog $i
    fi
    let index++
done

printLog
