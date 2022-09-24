{ lib, rustPlatform, fetchFromGitHub, pkgs, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "spin-framework";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "fermyon";
    repo = "spin";
    rev = "v${version}";
    sha256 = "sha256-UJiUXzbdvntzsIZ6bB69tiLR++S4I37f1+lcK1jqWxA=";
    leaveDotGit = true; # let vergen populate its various env vars
  };

  doCheck = false;

  patches = [
    # build.rs requires rustup by default as it validates your system has a wasm
    # target installed and then does some rudimentary building as a test of the
    # system. We can't do that in a nix build environment, so patch that out
    # without breaking vergen.
    ./build.patch
  ];

  nativeBuildInputs = with pkgs; [ pkg-config ] ++ lib.optional stdenv.isDarwin Security;
  buildInputs = with pkgs; [ openssl_3 ];

  cargoSha256 = "sha256-534zlEkea4wEwtcQ9N7dufyc738oKIWRlmxkz32K4S0=";

  meta = with lib; {
    description = "Spin is an open source framework for building and running fast, secure, and composable cloud microservices with WebAssembly";
    homepage = "https://spin.fermyon.dev/";
    license = licenses.asl20;
    maintainers = with maintainers; [ endocrimes ];
    platforms = platforms.unix;
  };
}
