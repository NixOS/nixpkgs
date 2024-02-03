# Tests the `projectReferences = [ ... ];` feature of buildDotnetModule.
# The `library` derivation exposes a .nupkg, which is then consumed by the `application` derivation.
# https://nixos.org/manual/nixpkgs/unstable/index.html#packaging-a-dotnet-application

{ lib
, dotnet_6
, runCommand
}:

let
  nugetDeps = ./nuget-deps.nix;

  # Specify the TargetFramework via an environment variable so that we don't
  # have to update the .csproj files when updating dotnet-sdk
  TargetFramework = "net${lib.versions.majorMinor (lib.getVersion dotnet_6.sdk)}";

  library = dotnet_6.buildDotnetModule {
    name = "project-references-test-library";
    src = ./library;
    inherit nugetDeps TargetFramework;

    packNupkg = true;
  };

  application = dotnet_6.buildDotnetModule {
    name = "project-references-test-application";
    src = ./application;
    inherit nugetDeps TargetFramework;

    projectReferences = [ library ];
  };
in

runCommand "project-references-test" { } ''
  ${application}/bin/Application
  touch $out
''
