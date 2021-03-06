# escape=`
FROM jenkins/jenkins:lts

# Switch to root to install .NET CORE SDK
USER root

RUN uname -a && cat /etc/*release

# Based on instructions at https://docs.microsoft.com/en-us/dotnet/core/linux-prerequisites?tabs=netcore2x
# Install depency for dotnet core 2.
RUN apt-get update `
    && apt-get install -y --no-install-recommends `
    curl libunwind8 gettext apt-transport-https && `
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg && `
    mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg && `
    sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-stretch-prod stretch main" > /etc/apt/sources.list.d/dotnetdev.list' && `
    apt-get update

# Install the .Net Core framework, set the path, and show the version of core installed.
RUN apt-get install -y dotnet-sdk-2.1 && `
    export PATH=$PATH:$HOME/dotnet && `
    dotnet --version

# Switch back to the jenkins user.
USER jenkins

# docker run -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home ccarlsson/jenkins:latest

