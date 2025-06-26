{
  lib,
  stdenv,
  fetchPypi,
  buildPythonPackage,
  pkgs,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  sqlite-vec-c, # alias for pkgs.sqlite-vec

  # optional dependencies
  numpy,

  # check inputs
  openai,
  pytestCheckHook,
}:

buildPythonPackage rec {
  inherit (sqlite-vec-c) pname version src;
  pyproject = true;

  sourceRoot = "${src.name}/bindings/python";

  # Install all the missing build files and a test
  postPatch = ''
    cp -rf ${./files}/* .
    chmod u+w -R sqlite_vec/
    mv extra_init.py sqlite_vec/
    substituteInPlace sqlite_vec/__init__.py \
      --replace "@libpath@" "${lib.getLib sqlite-vec-c}/lib/"
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    sqlite-vec-c
  ];

  optional-dependencies = {
    numpy = [
      numpy
    ];
  };

  nativeCheckInputs = [
    numpy
    openai
    pytestCheckHook
    sqlite-vec-c
  ];

  pythonImportsCheck = [ "sqlite_vec" ];

  meta = sqlite-vec-c.meta // {
    description = "Python bindings for sqlite-vec";
    maintainers = [ lib.maintainers.sarahec ];
  };
}
