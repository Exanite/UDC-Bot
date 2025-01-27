# Builds application using dotnet's sdk
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build

WORKDIR /
COPY ./DiscordBot/ ./app/
WORKDIR /app/

RUN dotnet restore
RUN dotnet build --configuration Release --no-restore


# Build finale image
FROM mcr.microsoft.com/dotnet/core/runtime:3.1

WORKDIR /app/

COPY --from=build /app/bin/Release/netcoreapp3.1/ ./

RUN echo "deb http://httpredir.debian.org/debian buster main contrib" > /etc/apt/sources.list
RUN echo "deb http://security.debian.org/ buster/updates main contrib" >> /etc/apt/sources.list
RUN echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections
RUN apt update
RUN apt install -y ttf-mscorefonts-installer
RUN apt clean
RUN apt autoremove -y
RUN rm -rf /var/lib/apt/lists/

ENTRYPOINT ["./DiscordBot"]
