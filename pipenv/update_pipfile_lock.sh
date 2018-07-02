#!/bin/sh

# generate the Pipfile for each env
# note: you need jinja2 installed in your global python env!

cd pipenv
python render_pipenv.py
cd ..

# generate the lock files (TODO: make this a function rather than copy-pasting)
cp -f pipenv/Pipfile.linux_gpu Pipfile
pipenv clean && pipenv lock
cp -f Pipfile.lock pipenv/Pipfile.lock.linux_gpu

cp -f pipenv/Pipfile.linux_cpu Pipfile
pipenv clean && pipenv lock
cp -f Pipfile.lock pipenv/Pipfile.lock.linux_cpu

# add to git for convenience
git add pipenv/Pipfile.lock.linux_gpu pipenv/Pipfile.lock.linux_cpu

# clean up
rm Pipfile Pipfile.lock