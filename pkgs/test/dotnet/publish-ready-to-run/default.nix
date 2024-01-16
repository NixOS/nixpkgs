# Validates that an application with PublishReadyToRun=true builds properly.
# This checks that the native Crossgen2 binary can run correctly and has all
# the needed dependencies.

{ lib
, dotnet-sdk
, TargetFramework
, buildDotnetModule
, runCommand
}:

let
  application = buildDotnetModule {
    name = "publish-ready-to-run-test-application";
    src = ./application;
    nugetDeps = ./nuget-deps.nix;

    projectFile = "application.csproj";

    inherit TargetFramework dotnet-sdk;
    dotnet-runtime = dotnet-sdk;
  };
in

runCommand "publish-ready-to-run-test" { } ''
  ${application}/bin/application
  touch $out
''
