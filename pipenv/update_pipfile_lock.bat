@echo off


:: generate the Pipfile for each env
cd pipenv
python render_pipenv.py
cd ..

:: generate the lock files (TODO: make this a function rather than copy-pasting)
copy /y pipenv\Pipfile.windows_gpu Pipfile
pipenv lock
copy /y Pipfile.lock pipenv\Pipfile.lock.windows_gpu

copy /y pipenv\Pipfile.windows_cpu Pipfile
pipenv lock
copy /y Pipfile.lock pipenv\Pipfile.lock.windows_cpu

:: add to git for convenience
git add pipenv/Pipfile.lock.windows_gpu pipenv/Pipfile.lock.windows_cpu

:: clean up
del Pipfile Pipfile.lock