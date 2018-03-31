{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper, llvmPackages }:

# Future work: Automatically communicate NIX_CFLAGS_COMPILE to bindgen's tests and the bindgen executable itself.

rustPlatform.buildRustPackage rec {
  name = "rust-bindgen-${version}";
  version = "0.35.0";

  src = fetchFromGitHub {
    owner = "rust-lang-nursery";
    repo = "rust-bindgen";
    rev = "v${version}";
    sha256 = "1qs67mkvrzwzi69rlq49p098h247197f2jiq1f4ivw9naggq5c7v";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ llvmPackages.clang-unwrapped.lib ];

  configurePhase = ''
    export LIBCLANG_PATH="${llvmPackages.clang-unwrapped.lib}/lib"
  '';

  postInstall = ''
    wrapProgram $out/bin/bindgen --set LIBCLANG_PATH "${llvmPackages.clang-unwrapped.lib}/lib"
  '';

  cargoSha256 = "0bh22fkynn1z83230pbj0gg5k3948f6m0idzyqjyfg1f3qmnzdi6";

  doCheck = false; # A test fails because it can't find standard headers in NixOS

  meta = with stdenv.lib; {
    description = "C and C++ binding generator";
    homepage = https://github.com/rust-lang-nursery/rust-bindgen;
    license = with licenses; [ bsd3 ];
    maintainers = [ maintainers.ralith ];
  };
}
