{
  lib,
  dotnet-sdk,
  buildPackages, # buildDotnetModule
  testers,
  runCommand,
}:
let
  copyrightString = "Original Copyright";
  originalCopyright = builtins.toFile "original-copyright.txt" copyrightString;
  overridenCopyright = builtins.toFile "overridden-copyright.txt" (
    copyrightString + " with override!"
  );

  inherit (buildPackages) buildDotnetModule;

  app-recursive = buildDotnetModule (finalAttrs: {
    name = "final-attrs-rec-test-application";
    src = ../structured-attrs/src;
    nugetDeps = ../structured-attrs/nuget-deps.json;
    dotnetFlags = [ "--property:Copyright=${finalAttrs.passthru.copyrightString}" ];
    env.TargetFramework = "net${lib.versions.majorMinor (lib.getVersion dotnet-sdk)}";
    __structuredAttrs = true;
    passthru = {
      inherit copyrightString;
    };
  });

  app-const = buildDotnetModule {
    name = "final-attrs-const-test-application";
    src = ../structured-attrs/src;
    nugetDeps = ../structured-attrs/nuget-deps.json;
    dotnetFlags = [ "--property:Copyright=${copyrightString}" ];
    env.TargetFramework = "net${lib.versions.majorMinor (lib.getVersion dotnet-sdk)}";
    __structuredAttrs = true;
    passthru = {
      inherit copyrightString;
    };
  };

  override =
    app:
    app.overrideAttrs (previousAttrs: {
      passthru = previousAttrs.passthru // {
        copyrightString = previousAttrs.passthru.copyrightString + " with override!";
      };
    });

  run =
    name: app:
    runCommand name { } ''
      ${app}/bin/Application >"$out"
    '';
in
{
  check-output = testers.testEqualContents {
    assertion = "buildDotnetModule produces the expected output when called with a recursive function";
    expected = originalCopyright;
    actual = run "dotnet-final-attrs-test-rec-output" app-recursive;
  };
  output-matches-const = testers.testEqualContents {
    assertion = "buildDotnetModule produces the same output when called with attrs or a recursive function";
    expected = run "dotnet-final-attrs-test-const" app-const;
    actual = run "dotnet-final-attrs-test-rec" app-recursive;
  };
  override-has-no-effect = testers.testEqualContents {
    assertion = "buildDotnetModule produces the expected output when called with a recursive function";
    expected = originalCopyright;
    actual = run "dotnet-final-attrs-test-override-const-output" (override app-const);
  };
  override-modifies-output = testers.testEqualContents {
    assertion = "buildDotnetModule produces the expected output when called with a recursive function";
    expected = overridenCopyright;
    actual = run "dotnet-final-attrs-test-override-rec-output" (override app-recursive);
  };
}
