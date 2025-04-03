{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-rust,
  rustPlatform,
  rustc,
  cargo,
  milksnake,
  cffi,
  pytestCheckHook,
  nixosTests,
}:

buildPythonPackage rec {
  pname = "symbolic";
  version = "10.2.1"; # glitchtip currently only works with symbolic 10.x
  pyproject = true;

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "symbolic";
    tag = version;
    hash = "sha256-3u4MTzaMwryGpFowrAM/MJOmnU8M+Q1/0UtALJib+9A=";
    # for some reason the `py` directory in the tarball is empty, so we fetch the source via git instead
    forceFetchGit = true;
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      postPatch
      ;
    hash = "sha256-cpIVzgcxKfEA5oov6/OaXqknYsYZUoduLTn2qIXGL5U=";
  };

  nativeBuildInputs = [
    setuptools-rust
    rustPlatform.cargoSetupHook
    rustc
    cargo
    milksnake
  ];

  dependencies = [ cffi ];

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  preBuild = ''
    cd py
  '';

  preCheck = ''
    cd ..
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "py" ];

  pythonImportsCheck = [ "symbolic" ];

  passthru.tests = { inherit (nixosTests) glitchtip; };

  meta = {
    description = "Python library for dealing with symbol files and more";
    homepage = "https://github.com/getsentry/symbolic";
    changelog = "https://github.com/getsentry/symbolic/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
  };
}
