@echo off 

for /d %%a in (*) do (
    echo %%~a
    cd %%~a
    git pull
    cd ..
)

pause
