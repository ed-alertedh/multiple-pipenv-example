FROM ubuntu:xenial

RUN apt-get update && apt-get install -y build-essential libz-dev libreadline-dev libncursesw5-dev libssl-dev libgdbm-dev libsqlite3-dev libbz2-dev curl git

# install pyenv
RUN curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
# add pyenv to path and premptively add our new python interpreter to the path too
ENV PATH=/root/.pyenv/bin:/root/.pyenv/versions/3.6.3/bin:${PATH}
# use pyenv to download and build the python version we want
RUN env PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install 3.6.3
RUN pyenv global 3.6.3

# add the dependencies for our scripts to work correctly
RUN pip install pipenv jinja2

# stop the click module in python complaining about ASCII encoding
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# run the update script from the root of the repo (mounted at /app in our container)
WORKDIR /app
ENTRYPOINT  ["/app/pipenv/update_pipfile_lock.sh"]