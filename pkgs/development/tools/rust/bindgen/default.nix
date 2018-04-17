{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper, llvmPackages }:

# Future work: Automatically communicate NIX_CFLAGS_COMPILE to bindgen's tests and the bindgen executable itself.

rustPlatform.buildRustPackage rec {
  name = "rust-bindgen-${version}";
  version = "0.36.0";

  src = fetchFromGitHub {
    owner = "rust-lang-nursery";
    repo = "rust-bindgen";
    rev = "v${version}";
    sha256 = "1bpya490qh2jvq99mdlcifj6mgn3yxr0sqas6y5xw842b46g6hi6";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ llvmPackages.clang-unwrapped.lib ];

  configurePhase = ''
    export LIBCLANG_PATH="${llvmPackages.clang-unwrapped.lib}/lib"
  '';

  postInstall = ''
    wrapProgram $out/bin/bindgen --set LIBCLANG_PATH "${llvmPackages.clang-unwrapped.lib}/lib"
  '';

  cargoSha256 = "0b8v6c7q1abibzygrigldpd31lyd5ngmj4vq5d7zni96m20mm85w";

  doCheck = false; # A test fails because it can't find standard headers in NixOS

  meta = with stdenv.lib; {
    description = "C and C++ binding generator";
    homepage = https://github.com/rust-lang-nursery/rust-bindgen;
    license = with licenses; [ bsd3 ];
    maintainers = [ maintainers.ralith ];
  };
}
