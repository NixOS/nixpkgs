{
  pkgs ? import <nixpkgs> { },
}:
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
in
{
  overridePythonAttrs-stdenv-correct =
    pkgs.clangStdenv == (package-stub.override (prev: {
      buildPythonPackage = prev.buildPythonPackage.override {
        stdenv = pkgs.clangStdenv;
      };
    })).stdenv;

  overridePythonAttrs-stdenv-deprecated =
    pkgs.clangStdenv == (package-stub.overridePythonAttrs (_: {
      stdenv = pkgs.clangStdenv;
    })).stdenv;

  overridePythonAttrs-override-clangStdenv-deprecated-nested =
    pkgs.clangStdenv == (
      (package-stub.overridePythonAttrs {
        stdenv = pkgs.gccStdenv;
      }).overridePythonAttrs
      {
        stdenv = pkgs.clangStdenv;
      }
    ).stdenv;

  buildPythonPackage-stdenv-deprecated = pkgs.gccStdenv == package-stub-gcc.stdenv;

  buildPythonPackage-fp-args-stdenv-deprecated = pkgs.gccStdenv == package-stub-fp-args-gcc.stdenv;
}
