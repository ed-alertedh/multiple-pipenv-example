@echo off
:: update windows lock files
call pipenv\update_pipfile_lock.bat

:: update linux lock files in docker container
docker build -t piplock ./pipenv
docker run -v %cd%:/app piplock