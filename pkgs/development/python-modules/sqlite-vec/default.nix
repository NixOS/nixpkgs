{
  lib,
  buildPythonPackage,
  fetchpatch,

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

  # The actual source root is bindings/python but the patches
  # apply to the bindings directory.
  # This is a known issue, see https://discourse.nixos.org/t/how-to-apply-patches-with-sourceroot/59727
  sourceRoot = "${src.name}/bindings";

  patches = [
    (fetchpatch {
      # https://github.com/asg017/sqlite-vec/pull/233
      name = "add-python-build-files.patch";
      url = "https://github.com/asg017/sqlite-vec/commit/c1917deb11aa79dcac32440679345b93e13b1b86.patch";
      hash = "sha256-4/9QLKuM/1AbD8AQHwJ14rhWVYVc+MILvK6+tWwWQlw=";
      stripLen = 1;
    })
    (fetchpatch {
      # https://github.com/asg017/sqlite-vec/pull/233
      name = "add-python-test.patch";
      url = "https://github.com/asg017/sqlite-vec/commit/608972c9dcbfc7f4583e99fd8de6e5e16da11081.patch";
      hash = "sha256-8dfw7zs7z2FYh8DoAxurMYCDMOheg8Zl1XGcPw1A1BM=";
      stripLen = 1;
    })
  ];

  # Change into the proper directory for building, move `extra_init.py` into its proper location,
  # and supply the path to the library.
  postPatch = ''
    cd python
    mv extra_init.py sqlite_vec/
    substituteInPlace sqlite_vec/__init__.py \
      --replace-fail "@libpath@" "${lib.getLib sqlite-vec-c}/lib/"
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
