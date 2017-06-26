{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper, llvmPackages }:

# Future work: Automatically communicate NIX_CFLAGS_COMPILE to bindgen's tests and the bindgen executable itself.

rustPlatform.buildRustPackage rec {
  name = "rust-bindgen-${version}";
  version = "0.25.5";

  src = fetchFromGitHub {
    owner = "servo";
    repo = "rust-bindgen";
    rev = "v${version}";
    sha256 = "0hv90h279frbxjay5g5vphds6wj3fiid9f2vmg1nr8887y4nif0k";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ llvmPackages.clang-unwrapped ];

  configurePhase = ''
    export LIBCLANG_PATH="${llvmPackages.clang-unwrapped}/lib"
  '';

  postInstall = ''
    wrapProgram $out/bin/bindgen --set LIBCLANG_PATH "${llvmPackages.clang-unwrapped}/lib"
  '';

  depsSha256 = "0ylm1wzf9aqcyfmmgpb18bdp5c5d73pnnjw13cv373511mkj1y0m";

  doCheck = false; # A test fails because it can't find standard headers in NixOS

  meta = with stdenv.lib; {
    description = "C binding generator";
    homepage = https://github.com/servo/rust-bindgen;
    license = with licenses; [ bsd3 ];
    maintainers = [ maintainers.ralith ];
  };
}
