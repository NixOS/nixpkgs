# Tests that projects build properly with -p:PublishTrimmed=true

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
    name = "publish-trimmed-test-application";
    src = ./application;
    nugetDeps = ./nuget-deps.nix;

    # PublishTrimmed requires self-contained build.
    # Without this set to true, buildDotnetModule overrides
    # the PublishTrimmed property to avoid errors.
    selfContainedBuild = true;

    inherit TargetFramework;
  };
in

runCommand "publish-trimmed-test" { } ''
  ${application}/bin/application
  touch $out
''
