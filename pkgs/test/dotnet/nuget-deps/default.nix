# Tests that `nugetDeps` in buildDotnetModule can handle various types.

{
  lib,
  dotnet-sdk,
  buildPackages, # buildDotnetModule
  runCommand,
}:

let
  inherit (lib)
    mapAttrs
    ;

  inherit (buildPackages)
    emptyDirectory
    buildDotnetModule
    ;

in
mapAttrs
  (
    name: nugetDeps:
    buildDotnetModule {
      name = "nuget-deps-${name}";
      unpackPhase = ''
        runHook preUnpack

        mkdir test
        cd test
        dotnet new console -o .
        ls -l

        runHook postUnpack
      '';
      inherit nugetDeps;
    }
  )
  {
    "null" = null;
    "nix-file" = ./nuget-deps.nix;
    "json-file" = ./nuget-deps.json;
    "derivation" = emptyDirectory;
    "list" = [ emptyDirectory ];
  }
