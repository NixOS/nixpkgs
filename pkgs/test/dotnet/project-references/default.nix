# Tests the `projectReferences = [ ... ];` feature of buildDotnetModule.
# The `library` derivation exposes a .nupkg, which is then consumed by the `application` derivation.
# https://nixos.org/manual/nixpkgs/unstable/index.html#packaging-a-dotnet-application

{ lib
, dotnet-sdk
, TargetFramework
, buildDotnetModule
, runCommand
}:

let
  nugetDeps = ./nuget-deps.nix;

  library = buildDotnetModule {
    name = "project-references-test-library";
    src = ./library;
    inherit nugetDeps TargetFramework dotnet-sdk;

    packNupkg = true;
  };

  application = buildDotnetModule {
    name = "project-references-test-application";
    src = ./application;
    inherit nugetDeps TargetFramework dotnet-sdk;
    dotnet-runtime = dotnet-sdk;

    projectReferences = [ library ];
  };
in

runCommand "project-references-test" { } ''
  ${application}/bin/Application
  touch $out
''
