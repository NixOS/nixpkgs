{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper, llvmPackages }:

# Future work: Automatically communicate NIX_CFLAGS_COMPILE to bindgen's tests and the bindgen executable itself.

rustPlatform.buildRustPackage rec {
  name = "rust-bindgen-${version}";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "servo";
    repo = "rust-bindgen";
    rev = "v${version}";
    sha256 = "1nzva8g5nj7m2w8vax86p4rd02ci8793nhnm7sf76ajr4hfnx323";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ llvmPackages.clang-unwrapped ];

  configurePhase = ''
    export LIBCLANG_PATH="${llvmPackages.clang-unwrapped}/lib"
  '';

  postInstall = ''
    wrapProgram $out/bin/bindgen --set LIBCLANG_PATH "${llvmPackages.clang-unwrapped}/lib"
  '';

  depsSha256 = "1l8c48y67azzwmv4hzghia1c53b5dw6qiv22cgv8zbyrg20aj8as";

  doCheck = false; # A test fails because it can't find standard headers in NixOS

  meta = with stdenv.lib; {
    description = "C binding generator";
    homepage = https://github.com/servo/rust-bindgen;
    license = with licenses; [ bsd3 ];
    maintainers = [ maintainers.ralith ];
  };
}
