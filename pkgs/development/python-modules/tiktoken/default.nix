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
<<<<<<< HEAD
  version = "0.12.0";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sYun7isJOGOXj8sU90s3B83I1NTTg2hTzn7GB3ITmTE=";
=======
  version = "0.9.0";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0Cpcpqk44EkOH/lXvEjIsHjIjLg5d74WJbH9iqx5LF0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    hash = "sha256-daIKasW/lwYwIqMs3KvCDJWAoMn1CkPRpNqhl1jKpYY=";
=======
    hash = "sha256-MfTTRbSM+KgrYrWHYlJkGDc1qn3oulalDJM+huTaJ0g=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Fast BPE tokeniser for use with OpenAI's models";
    homepage = "https://github.com/openai/tiktoken";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
=======
  meta = with lib; {
    description = "Fast BPE tokeniser for use with OpenAI's models";
    homepage = "https://github.com/openai/tiktoken";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
