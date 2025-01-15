FROM elixir:otp-27

# TODO: non-privileged user doesn't have permissions to /tmp/mix_pubsub/ for GenServer Mix.Sync.PubSub
# ARG USERNAME=appuser
# ARG USER_UID=1000
# ARG USER_GID=$USER_UID

# RUN groupadd --gid ${USER_GID} ${USERNAME} \
#    && useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME}

WORKDIR /islands_engine

COPY . .

RUN apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_23.x -o nodesource_setup.sh && \
    bash nodesource_setup.sh && \
    apt-get install -y nodejs

RUN mix archive.install hex phx_new

# USER ${USERNAME}
