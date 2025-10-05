{
  lib,
  stdenv,
  cargo,
  fetchPypi,
  buildPythonPackage,
  isPy3k,
  rustPlatform,
  rustc,
  setuptools-rust,
  libiconv,
}:

buildPythonPackage rec {
  pname = "spacy-alignments";
  version = "0.9.0";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jcNYghWR9Xbu97/hAYe8ewa5oMQ4ofNGFwY4cY7/EmM=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-0U1ELUMh4YV6M+zrrZGuzvY8SdgyN66F7bJ6sMhOdXs=";
  };

  nativeBuildInputs = [
    setuptools-rust
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  # Fails because spacy_alignments module cannot be loaded correctly.
  doCheck = false;

  pythonImportsCheck = [ "spacy_alignments" ];

  meta = with lib; {
    description = "Align tokenizations for spaCy and transformers";
    homepage = "https://github.com/explosion/spacy-alignments";
    license = licenses.mit;
    maintainers = [ ];
  };
}
