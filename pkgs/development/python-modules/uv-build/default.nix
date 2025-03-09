{
  buildPythonPackage,
  fetchpatch,
  rustPlatform,
  pkgs,
  lib,
}:

buildPythonPackage {
  pname = "uv-build";
  pyproject = true;

  inherit (pkgs.uv)
    version
    src
    cargoDeps
    cargoBuildFlags
    versionCheckProgramArg
    ;

  patches = [
    # uv's v0.6.5 release contains a uv-build with v0.6.3, which is the wrong version number.
    # https://github.com/astral-sh/uv/pull/12019 has been merged, but no release has been cut yet.
    (fetchpatch {
      url = "https://github.com/astral-sh/uv/commit/f18e6ef6d4b8931b68654cfd2609355c67727e3b.patch";
      includes = [ "crates/uv-build/pyproject.toml" ];
      hash = "sha256-F+WepD1WwRibEkisLgIRHQ84HKXx7ZUX75y3nQe987o=";
    })

    # uv's v0.6.5 release contains a uv-build that used the old UV cli interface.
    # https://github.com/astral-sh/uv/pull/12058 has been merged, but no release has been cut yet.
    (fetchpatch {
      url = "https://github.com/astral-sh/uv/commit/b2a0ea3701482dd5201fbaa98c2d79adee9d426e.patch";
      includes = [ "crates/uv-build/python/uv_build/__init__.py" ];
      hash = "sha256-BK8uHRuwqCXXNbM8J/zFi1HNEtQqCXMCqe4w7fdTOo4=";
    })
  ];

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildAndTestSubdir = "crates/uv-build";

  # $src/.github/workflows/build-binaries.yml#L139
  maturinBuildFlags = [ "--profile=minimal-size" ];

  pythonImportsCheck = [ "uv_build" ];

  meta = {
    description = "A minimal build backend for uv";
    inherit (pkgs.uv.meta) homepage changelog license;
    maintainers = with lib.maintainers; [ bengsparks ];
  };
}
