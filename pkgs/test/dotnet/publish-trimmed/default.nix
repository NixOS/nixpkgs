# Tests that projects build properly with -p:PublishTrimmed=true

{ lib
, dotnet-sdk
, TargetFramework
, buildDotnetModule
, runCommand
}:

let
  application = buildDotnetModule {
    name = "publish-trimmed-test-application";
    src = ./application;
    nugetDeps = ./nuget-deps.nix;

    # PublishTrimmed requires self-contained build.
    # Without this set to true, buildDotnetModule overrides
    # the PublishTrimmed property to avoid errors.
    selfContainedBuild = true;

    inherit TargetFramework dotnet-sdk;
  };
in

runCommand "publish-trimmed-test" { } ''
  ${application}/bin/application
  touch $out
''
