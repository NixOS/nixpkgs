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
  version = "0.8.3";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zrqBjaIjtF6bJMbmw7Zo+BeApN6sxxfLkrzsDjdvC78=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit patches src;
    name = "${pname}-${version}";
    hash = "sha256-YRyG2yflEXKklNqXiDD9oK3J1lq4o704+Eeu2hyY3xI=";
  };

  patches = [
    # Add Cargo.lock, from upstream PR:
    # https://github.com/explosion/spacy-alignments/pull/3
    (fetchpatch {
      url = "https://github.com/explosion/spacy-alignments/commit/7b0ba13ff0d245bfbbe344a36fb7bbd311dd4906.diff";
      sha256 = "sha256-jx97SSC+3z+ByInNs8Uq58H50eCo4fDCwEi6VKxRs2k=";
      excludes = [ ".gitignore" ];
    })
  ];

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
