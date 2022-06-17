当前目录拉取github（githubpull.bat）
====
``` C++
@echo off 

for /d %%a in (*) do (
    echo %%~a
    cd %%~a
    git pull
    cd ..
)

pause

```
