{ fetchPypi, fetchpatch, buildPythonPackage, pkgs, lib, rustPlatform, regex, requests, blobfile, setuptools-rust }:

buildPythonPackage rec {
  pname = "tiktoken";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-JHak9NKSk3YtwzINUNhmIC1+HFYqw3inhd3lEFfc714=";
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  propagatedBuildInputs = [ regex requests blobfile ];

  nativeBuildInputs = [ setuptools-rust ] ++ (with rustPlatform; [
    rust.rustc
    rust.cargo
    cargoSetupHook
    maturinBuildHook
  ]);

  meta = with lib; {
    description = "a fast BPE tokeniser for use with OpenAI's models.";
    license = licenses.mit;
    maintainers = with maintainers; [ realsnick ];
    homepage = "https://github.com/openai/tiktoken";
  };
}
