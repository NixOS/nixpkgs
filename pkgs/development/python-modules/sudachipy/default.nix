{
  lib,
  stdenv,
  buildPythonPackage,
  cargo,
  libiconv,
  rustPlatform,
  rustc,
  sudachi-rs,
  setuptools-rust,
  pytestCheckHook,
  sudachidict-core,
  tokenizers,
  sudachipy,
}:

buildPythonPackage rec {
  format = "setuptools";
  pname = "sudachipy";
  inherit (sudachi-rs) src version;

  patches = sudachi-rs.cargoPatches;

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    patches = sudachi-rs.cargoPatches;
    hash = "sha256-lUP/9s4W0JehxeCjMmq6G22KMGdDNnq1YlobeLQn2AE=";
  };

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustc
    setuptools-rust
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  preBuild = ''
    cd python
  '';

  # avoid infinite recursion due to sudachidict
  doCheck = false;

  nativeCheckInputs = [
    pytestCheckHook
    sudachidict-core
    tokenizers
  ];

  pythonImportsCheck = [ "sudachipy" ];

  passthru = {
    inherit (sudachi-rs) updateScript;
    tests = {
      pytest = sudachipy.overridePythonAttrs (_: {
        doCheck = true;
        # avoid catchConflicts of sudachipy
        # we don't need to install this package since it is just a test
        dontInstall = true;
      });
    };
  };

  meta = sudachi-rs.meta // {
    homepage = "https://github.com/WorksApplications/sudachi.rs/tree/develop/python";
    mainProgram = "sudachipy";
  };
}
