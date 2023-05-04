{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, rustPlatform
, setuptools-rust
, libiconv
, requests
, regex
, blobfile
}:
let
  pname = "tiktoken";
  version = "0.3.3";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-l7WLe/2pRXkeyFXlPRZujsIMY3iUK5OFGmyRnd+dBJY=";
  };
  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';
in
buildPythonPackage {
  inherit pname version src postPatch;
  format = "setuptools";

  disabled = pythonOlder "3.8";

  nativeBuildInput = [
    setuptools-rust
  ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src postPatch;
    name = "${pname}-${version}";
    hash = "sha256-27xR7xVH/u40Xl4VbJW/yEbURf0UcGPG5QK/04igseA=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    setuptools-rust
  ] ++ (with rustPlatform; [ rust.cargo rust.rustc ]);

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  propagatedBuildInputs = [
    requests
    regex
    blobfile
  ];

  meta = with lib; {
    description = "tiktoken is a fast BPE tokeniser for use with OpenAI's models.";
    homepage = "https://github.com/openai/tiktoken";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
