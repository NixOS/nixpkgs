{ lib
, stdenv
, fetchPypi
, fetchpatch
, buildPythonPackage
, isPy3k
, rustPlatform
, setuptools-rust
, libiconv
}:

buildPythonPackage rec {
  pname = "spacy-alignments";
  version = "0.8.4";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1HApl/RZ0w5Tf2OPu1QBUa36uIqilp+dDbPjujn0e9s=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-oFSruBnoodv6/0/OrmJ/2SVoWm3u3FGtzVJ9xgp0+Cg=";
  };

  nativeBuildInputs = [
    setuptools-rust
  ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ]);

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
