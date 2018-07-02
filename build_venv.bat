@echo off
setlocal

IF "%~1"=="" (set ENV_NAME=windows_gpu) ELSE (set ENV_NAME=windows_%1)

echo Building environment for %ENV_NAME%

:: generate the Pipfile for each env
cd pipenv
python render_pipenv.py
cd ..

copy /y pipenv\Pipfile.lock.%ENV_NAME% Pipfile.lock
copy /y pipenv\Pipfile.%ENV_NAME% Pipfile
pipenv --rm
pipenv install --dev --deploy
:: pipenv run nbstripout --install --attributes .gitattributes

endlocal