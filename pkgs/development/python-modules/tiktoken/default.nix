{ fetchPypi, buildPythonPackage, pkgs, lib, setuptools-rust, rustPlatform }:

let
  pkgs = import <nixpkgs> { };
  rustPlatform = pkgs.rustPlatform;
in

buildPythonPackage rec {
  pname = "tiktoken";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "30Gj1HhJl1e1sy6uXpdlfPFZ2NnmdkBJ3Xw6u0nhtA8=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-heOBK8qi2nuc/Ib+I/vLzZ1fUUD/G/KTw9d7M4Hz5O0=";
  };

  nativeBuildInputs = [ setuptools-rust ] ++ (with rustPlatform; [
    rust.cargo
    rust.rustc
    cargoSetupHook
  ]);

  #  preBuild = ''
  #    ${ rustPlatform.cargoGenerateLockfile } --manifest-path=${src}/Cargo.toml
  #  '';

  meta = with lib; {
    description = "a fast BPE tokeniser for use with OpenAI's models.";
    license = licenses.mit;
    maintainers = with maintainers; [ realsnick ];
    homepage = "https://github.com/openai/tiktoken";
  };
}
