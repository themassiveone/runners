FROM ubuntu:22.04

# install docker-engine
RUN apt-get update \
    && apt-get install -y ca-certificates curl \
    && install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc \
    && chmod a+r /etc/apt/keyrings/docker.asc \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# install dotnet-8 \
RUN apt-get update && \
    apt-get install -y dotnet-sdk-8.0 


# Install NugetForUnity
RUN dotnet tool install --global NuGetForUnity.Cli
ENV PATH="$PATH:/root/.dotnet/tools"

# install github runner
RUN mkdir actions-runner && cd actions-runner \
    && curl -o actions-runner-linux-x64-2.317.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.317.0/actions-runner-linux-x64-2.317.0.tar.gz \
    && echo "9e883d210df8c6028aff475475a457d380353f9d01877d51cc01a17b2a91161d  actions-runner-linux-x64-2.317.0.tar.gz" | shasum -a 256 -c \
    && tar xzf ./actions-runner-linux-x64-2.317.0.tar.gz 

WORKDIR actions-runner

# get token fetch script
COPY ./start-runner.sh .
RUN chmod +x ./start-runner.sh


RUN apt-get install -y jq
ENV RUNNER_ALLOW_RUNASROOT=1
 
ENTRYPOINT "./start-runner.sh"