# Simple test to validate the most basic building works

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
    name = "simple-build-test-application";
    src = ./application;
    nugetDeps = ./nuget-deps.nix;

    inherit TargetFramework;
  };
in

runCommand "simple-build-test" { } ''
  ${application}/bin/application
  touch $out
''
