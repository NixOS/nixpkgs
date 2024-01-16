# Simple test to validate the most basic building works

{ lib
, dotnet-sdk
, TargetFramework
, buildDotnetModule
, runCommand
}:

let
  application = buildDotnetModule {
    name = "simple-build-test-application";
    src = ./application;
    nugetDeps = ./nuget-deps.nix;

    inherit TargetFramework dotnet-sdk;
    dotnet-runtime = dotnet-sdk;
  };
in

runCommand "simple-build-test" { } ''
  ${application}/bin/application
  touch $out
''
