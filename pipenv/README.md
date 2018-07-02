# Python Environment Management
## TL;DR
To get a python environment going:

1. Install `pipenv` and `jinja2` in your global python installation.
2. On Windows, run `build_venv.bat` from the root of this folder. On linux, run `build_venv.sh`.*
3. To use the environment to run a script, run `pipenv run python <script.py>`
4. To use the environment to run Jupyter notebook, run `pipenv run jupyter notebook`
5. To use the environment to run Tensorboard, run `pipenv run tensorboard`
 
*if you need a cpu-only environment, run `build_venv.bat cpu` or `build_venv.sh cpu` instead

## Adding new packages

*Avoid using pip directly if you want your new packages to stick around!*

1. Add the extra packages to Pipfile.tmpl and commit the changes.
2. To update the windows lock files, run `pipenv\update_pipfile_lock.bat` from the root of the repository on Windows
and commit the updated lock files (the script automatically runs `git add`).
3. To update the Linux lock files, run `./pipenv/update_pipfile_lock.sh` from the root of the repository on Linux
and commit the updated lock files.
4. Sync your environments to the new set of packages in version control using the `build_venv` script.

## What's going on here? That's a lot of files!
We're trying to solve a few problems here:
 1. We want a standardised set of packages to run our code with which is stored under version control.
 1. We want to make it easy to upgrade packages in our standardised set.
 1. We want our code to run on both Linux and Windows.
 1. We want our code to run on systems with and without CUDA installed.
 
Pipenv solves problems #1 and #2. It provides a system where you can specify the packages you're using and any version
constraints in a `Pipfile`. Unlike requirements.txt, you don't need to list versions/version constraints of the dependencies pulled in
by other packages. To get a baselined set of packages, you do need to record the versions of all the dependencies too -
Pipenv stores this in `Pipfile.lock`. By storing `Pipfile` and `Pipfile.lock` under version control, we have a record of
_how_ we built our set of packages (which solves problem #2) as well as the set of packages itself (which solves problem #1).

Problem #3 complicates things. There are a few packages on Windows where we need to install one of Chris Gohlke's
unofficial builds rather than pulling from pypi.org.
Pipenv does allow you to install local .whl files and even install certain packages only on a certain OS, but when you go
to generate `Pipfile.lock` you'll get a different set of packages depending on whether you ran it on Linux or Windows.
This doesn't really seem to be Pipenv's fault, it's just a result of the fact that python wheels are allowed to change
their dependencies depending on which OS they are on.

Problem #4 does not appear to be solvable with Pipenv alone since it would require the ability to set custom flags for
package installation (see https://github.com/pypa/pipenv/issues/1353).

To solve problems #3 and #4, I've resorted to templating. We have a master `Pipfile` template (`Pipfile.tmpl`) which
is used to generate a Pipfile for each different environment (Windows/Linux + CPU/GPU). These generated Pipfiles don't
need to be committed and have been added to .gitignore. The generated Pipfiles are then moved into place so pipenv can
see them and are used to generate a Pipenv.lock for each environment. The resulting Pipfile.lock is renamed and moved
into this folder to be stored under version control. The "build_venv" scripts basically do the reverse and make sure the
correct Pipfile and Pipfile.lock are moved into place for the desired environment.

## Docker too?!
As a bonus, a Docker container is provided which lets you generate the Linux lock files easily from Windows.
With this set up, updating the environments becomes even easier since it can all be run and committed from one machine.
Running the script `pipenv\update_all_pipfile_lock.bat` from the root of the repository on Windows should take care
of everything (but you'll need Docker for Windows installed and the first time you do this it will take a while to 
build the Docker container).