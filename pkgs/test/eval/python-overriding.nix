{ pkgs, lib }:
let
  package-stub = pkgs.python3Packages.callPackage (
    {
      buildPythonPackage,
      emptyDirectory,
    }:
    buildPythonPackage {
      pname = "python-package-stub";
      version = "0.1.0";
      pyproject = true;
      src = emptyDirectory;
    }
  ) { };

  package-stub-gcc = pkgs.python3Packages.callPackage (
    {
      buildPythonPackage,
      emptyDirectory,
      gccStdenv,
    }:
    buildPythonPackage {
      pname = "python-package-stub";
      version = "0.1.0";
      pyproject = true;
      src = emptyDirectory;
      stdenv = gccStdenv;
    }
  ) { };

  package-stub-fp-args-gcc = pkgs.python3Packages.callPackage (
    {
      buildPythonPackage,
      emptyDirectory,
      gccStdenv,
    }:
    buildPythonPackage (_: {
      pname = "python-package-stub";
      version = "0.1.0";
      pyproject = true;
      src = emptyDirectory;
      stdenv = gccStdenv;
    })
  ) { };

  stdenvDeprecationWarningPattern =
    lib.escapeRegex ''
      evaluation warning: python-package-stub: Passing `stdenv` directly to `buildPythonPackage` or `buildPythonApplication` is deprecated. You should use their `.override` function instead, e.g:
                            buildPythonPackage.override { stdenv = customStdenv; } { }
                          `stdenv` argument found at ${toString __curPos.file}:''
    + "[0-9]+\n";

  stdenvDeprecationWarning =
    { stderrFile, ... }:
    let
      stderr = builtins.readFile stderrFile;
      result = builtins.match stdenvDeprecationWarningPattern stderr;
    in
    lib.throwIf (result == null) "expected stdenv deprecation warning" true;
in
{
  overridePythonAttrs-stdenv-correct = {
    expr =
      pkgs.clangStdenv == (package-stub.override (prev: {
        buildPythonPackage = prev.buildPythonPackage.override {
          stdenv = pkgs.clangStdenv;
        };
      })).stdenv;
    stderr = "";
  };

  overridePythonAttrs-stdenv-deprecated = {
    expr =
      pkgs.clangStdenv == (package-stub.overridePythonAttrs (_: {
        stdenv = pkgs.clangStdenv;
      })).stdenv;
    test = stdenvDeprecationWarning;
  };

  overridePythonAttrs-override-clangStdenv-deprecated-nested = {
    expr =
      pkgs.clangStdenv == (
        (package-stub.overridePythonAttrs {
          stdenv = pkgs.gccStdenv;
        }).overridePythonAttrs
        {
          stdenv = pkgs.clangStdenv;
        }
      ).stdenv;
    test =
      { stderrFile, ... }:
      let
        stderr = builtins.readFile stderrFile;
        pattern = stdenvDeprecationWarningPattern + stdenvDeprecationWarningPattern;
        result = builtins.match pattern stderr;
      in
      lib.throwIf (result == null) "expected 2 stdenv deprecation warnings" true;
  };

  buildPythonPackage-stdenv-deprecated = {
    expr = pkgs.gccStdenv == package-stub-gcc.stdenv;
    test = stdenvDeprecationWarning;
  };

  buildPythonPackage-fp-args-stdenv-deprecated = {
    expr = pkgs.gccStdenv == package-stub-fp-args-gcc.stdenv;
    test = stdenvDeprecationWarning;
  };
}
