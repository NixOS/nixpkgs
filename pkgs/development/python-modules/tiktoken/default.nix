{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  rustPlatform,
  cargo,
  rustc,
  setuptools,
  setuptools-rust,
  libiconv,
  requests,
  regex,
  blobfile,
}:
let
  pname = "tiktoken";
  version = "0.9.0";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0Cpcpqk44EkOH/lXvEjIsHjIjLg5d74WJbH9iqx5LF0=";
  };
  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';
in
buildPythonPackage {
  inherit
    pname
    version
    src
    postPatch
    ;
  pyproject = true;

  disabled = pythonOlder "3.8";

  build-system = [
    setuptools
    setuptools-rust
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      postPatch
      ;
    hash = "sha256-MfTTRbSM+KgrYrWHYlJkGDc1qn3oulalDJM+huTaJ0g=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    setuptools-rust
    cargo
    rustc
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  dependencies = [
    requests
    regex
    blobfile
  ];

  # almost all tests require network access
  doCheck = false;

  pythonImportsCheck = [ "tiktoken" ];

  meta = with lib; {
    description = "Fast BPE tokeniser for use with OpenAI's models";
    homepage = "https://github.com/openai/tiktoken";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
