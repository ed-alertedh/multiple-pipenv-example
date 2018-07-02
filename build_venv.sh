#!/bin/sh

if [ $# -eq 0 ]
then
    ENV_NAME=linux_gpu
else
    ENV_NAME=linux_$1
fi

echo Building environment for $ENV_NAME

cd pipenv
python render_pipenv.py
cd ..

cp -f pipenv/Pipfile.lock.$ENV_NAME Pipfile.lock
cp -f pipenv/Pipfile.$ENV_NAME Pipfile
pipenv --rm || true # continue if nothing to rm
pipenv install --dev --deploy