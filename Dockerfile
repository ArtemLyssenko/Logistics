FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build-env
WORKDIR /app
EXPOSE 80
RUN bash

# Copy csproj and restore as distinct layers
COPY ./Logistics.Web/*.csproj /app
RUN dotnet restore

# Copy everything else and build
COPY ./Logistics.Web /app
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:2.2
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "Logistics.Web.dll"]