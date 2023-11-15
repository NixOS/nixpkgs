# Validates that an application with PublishReadyToRun=true builds properly.
# This checks that the native Crossgen2 binary can run correctly and has all
# the needed dependencies.

{ lib
, dotnet-sdk
, buildDotnetModule
, runCommand
}:

let
  # Specify the TargetFramework via an environment variable so that we don't
  # have to update the .csproj files when updating dotnet-sdk
  TargetFramework = "net${lib.versions.majorMinor (lib.getVersion dotnet-sdk)}";

  application = buildDotnetModule {
    name = "publish-ready-to-run-test-application";
    src = ./application;
    nugetDeps = ./nuget-deps.nix;

    projectFile = "application.csproj";

    inherit TargetFramework;
  };
in

runCommand "publish-ready-to-run-test" { } ''
  ${application}/bin/application
  touch $out
''
