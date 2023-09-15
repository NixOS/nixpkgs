{ lib
, stdenv
, cargo
, fetchPypi
, buildPythonPackage
, isPy3k
, rustPlatform
, rustc
, setuptools-rust
, libiconv
}:

buildPythonPackage rec {
  pname = "spacy-alignments";
  version = "0.9.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jcNYghWR9Xbu97/hAYe8ewa5oMQ4ofNGFwY4cY7/EmM=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-I5uI+qFyb4/ArpUZi4yS/E/bmwoW7+CalMq02Gnm9S8=";
  };

  nativeBuildInputs = [
    setuptools-rust
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  # Fails because spacy_alignments module cannot be loaded correctly.
  doCheck = false;

  pythonImportsCheck = [ "spacy_alignments" ];

  meta = with lib; {
    description = "Align tokenizations for spaCy and transformers";
    homepage = "https://github.com/explosion/spacy-alignments";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
