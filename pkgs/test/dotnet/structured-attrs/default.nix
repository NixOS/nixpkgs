{ lib
, dotnet-sdk
, buildPackages # buildDotnetModule
, testers
, runCommand
}:
let
  # Note: without structured attributes, we can’t use derivation arguments that
  # contain spaces unambiguously because arguments are passed as space-separated
  # environment variables.
  copyrightString = "Public domain 🅮";

  inherit (buildPackages) buildDotnetModule;

  app = buildDotnetModule {
    name = "structured-attrs-test-application";
    src = ./src;
    nugetDeps = ./nuget-deps.nix;
    dotnetFlags = [ "--property:Copyright=${copyrightString}" ];
    env.TargetFramework = "net${lib.versions.majorMinor (lib.getVersion dotnet-sdk)}";
    __structuredAttrs = true;
  };
in
{
  no-structured-attrs = testers.testBuildFailure (app.overrideAttrs {
    __structuredAttrs = false;
  });

  check-output = testers.testEqualContents {
    assertion = "buildDotnetModule sets AssemblyCopyrightAttribute with structured attributes";
    expected = builtins.toFile "expected-copyright.txt" copyrightString;
    actual = runCommand "dotnet-structured-attrs-test" { } ''
      ${app}/bin/Application >"$out"
    '';
  };
}
