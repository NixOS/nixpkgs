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
  version = "0.8.0";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nMuydA8kVCU0NpxWNc/ZsrPCSQdUp4rIgx2Z+J+U7rI=";
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

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src postPatch;
    name = "${pname}-${version}";
    hash = "sha256-XzUEqiUdi70bgQwARGHsgti36cFOh7QDiEkccjxlwls=";
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
    description = "tiktoken is a fast BPE tokeniser for use with OpenAI's models";
    homepage = "https://github.com/openai/tiktoken";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
