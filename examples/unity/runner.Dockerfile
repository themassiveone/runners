FROM alpine:latest

# Install Docker and openrc
RUN apk add --no-cache docker openrc && \
    addgroup root docker && \
    rc-update add docker boot 


# Install dotnet 7
RUN  apk add --no-cache \
     bash \
     ca-certificates-bundle \
     libgcc \
     libssl3 \
     libstdc++ \
     zlib \
     libgdiplus \
     icu-libs \
     && wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh && \
     chmod +x ./dotnet-install.sh && \
     ./dotnet-install.sh --version latest --channel 8.0
    
# Set environment variables for .NET
ENV DOTNET_ROOT=/root/.dotnet \
    PATH=$PATH:/root/.dotnet:/root/.dotnet/tools \
    DOTNET_CLI_TELEMETRY_OPTOUT=1

# Install NugetForUnity
RUN dotnet tool install --global NuGetForUnity.Cli

# Install Github Runner
RUN apk add --no-cache curl \
    musl-dev \
    && mkdir actions-runner && cd actions-runner \
    && curl -o actions-runner-linux-x64-2.317.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.317.0/actions-runner-linux-x64-2.317.0.tar.gz \
    && echo "9e883d210df8c6028aff475475a457d380353f9d01877d51cc01a17b2a91161d  actions-runner-linux-x64-2.317.0.tar.gz" | sha256sum -c - \
    && tar xzf ./actions-runner-linux-x64-2.317.0.tar.gz
ENV RUNNER_ALLOW_RUNASROOT=1
WORKDIR actions-runner


# configure runner
COPY fetch-token.sh ./
RUN ./bin/installdependencies.sh
RUN chmod +x ./fetch-token.sh
RUN ./config.sh --url https://github.com/${GITHUB_ORG} --token $(./fetch-token.sh) 
