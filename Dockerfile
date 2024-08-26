FROM python:3.10.4-slim-bullseye
ENV PYTHONBUFFERED 1

ARG USERNAME=webinative
# replace with your actual UID and GID if not the default 1000
ARG USER_UID=1000
ARG USER_GID=${USER_UID}

# create user
RUN groupadd --gid $USER_GID ${USERNAME} \
    && useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} \
    # create a folder for vscode editor stuff
    && mkdir -p /home/${USERNAME}/.vscode-server \
    && chown ${USER_UID}:${USER_GID} /home/${USERNAME}/.vscode-server \
    # create a folder for project code
    && mkdir -p /home/${USERNAME}/code \
    && chown ${USER_UID}:${USER_GID} /home/${USERNAME}/code \
    # add sudo support
    && apt-get update && apt-get install -y sudo \
    && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

# install git and psycopg3 dependencies
RUN apt-get update && apt-get install -y git libpq5

USER ${USERNAME}
WORKDIR /home/${USERNAME}/code
ADD pip-requirements /home/${USERNAME}/code/

# install python packages locally for user "webinative"
RUN pip install -r pip-requirements

# remove psycopg3 dependencies
RUN sudo apt-get remove -y libpq5

# not switching back to "root" user
