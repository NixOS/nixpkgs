{ lib
, dotnet-sdk
, buildPackages # buildDotnetModule, dotnet-runtime
, testers
, runCommand
, removeReferencesTo
}:
let
  inherit (buildPackages) buildDotnetModule dotnet-runtime;

  app = buildDotnetModule {
    name = "use-dotnet-from-env-test-application";
    src = ./src;
    nugetDeps = ./nuget-deps.nix;
    useDotnetFromEnv = true;
    env.TargetFramework = "net${lib.versions.majorMinor (lib.getVersion dotnet-sdk)}";
  };

  appWithoutFallback = app.overrideAttrs (oldAttrs: {
    nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [
      removeReferencesTo
    ];
    postFixup = (oldAttrs.postFixup or "") + ''
      remove-references-to -t ${dotnet-runtime} "$out/bin/Application"
    '';
  });

  runtimeVersion = lib.getVersion dotnet-runtime;
  runtimeVersionFile = builtins.toFile "dotnet-version.txt" runtimeVersion;
in
{
  fallback = testers.testEqualContents {
    assertion = "buildDotnetModule sets fallback DOTNET_ROOT in wrapper";
    expected = runtimeVersionFile;
    actual = runCommand "use-dotnet-from-env-fallback-test" { } ''
      ${app}/bin/Application >"$out"
    '';
  };

  # Check that appWithoutFallback does not use fallback .NET runtime.
  without-fallback = testers.testBuildFailure (runCommand "use-dotnet-from-env-without-fallback-test" { } ''
    ${appWithoutFallback}/bin/Application >"$out"
  '');

  # NB assumes that without-fallback above to passes.
  use-dotnet-root-env = testers.testEqualContents {
    assertion = "buildDotnetModule uses DOTNET_ROOT from environment in wrapper";
    expected = runtimeVersionFile;
    actual = runCommand "use-dotnet-from-env-root-test" { env.DOTNET_ROOT = dotnet-runtime; } ''
      ${appWithoutFallback}/bin/Application >"$out"
    '';
  };
  use-dotnet-path-env = testers.testEqualContents {
    assertion = "buildDotnetModule uses DOTNET_ROOT from dotnet in PATH in wrapper";
    expected = runtimeVersionFile;
    actual = runCommand "use-dotnet-from-env-path-test" { dotnetRuntime = dotnet-runtime; } ''
      PATH=$dotnetRuntime''${PATH+:}$PATH ${appWithoutFallback}/bin/Application >"$out"
    '';
  };
}
