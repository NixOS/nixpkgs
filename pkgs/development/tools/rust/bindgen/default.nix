{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper, llvmPackages }:

# Future work: Automatically communicate NIX_CFLAGS_COMPILE to bindgen's tests and the bindgen executable itself.

rustPlatform.buildRustPackage rec {
  name = "rust-bindgen-${version}";
  version = "0.32.1";

  src = fetchFromGitHub {
    owner = "rust-lang-nursery";
    repo = "rust-bindgen";
    rev = version;
    sha256 = "15m1y468c7ixzxwx29wazag0i19a3bmzjp53np6b62sf9wfzbsfa";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ llvmPackages.clang-unwrapped ];

  configurePhase = ''
    export LIBCLANG_PATH="${llvmPackages.clang-unwrapped}/lib"
  '';

  postInstall = ''
    wrapProgram $out/bin/bindgen --set LIBCLANG_PATH "${llvmPackages.clang-unwrapped}/lib"
  '';

  cargoSha256 = "01h0y5phdv3ab8mk2yxw8lgg9783pjjnjl4087iddqhqanlv600d";

  doCheck = false; # A test fails because it can't find standard headers in NixOS

  meta = with stdenv.lib; {
    description = "C and C++ binding generator";
    homepage = https://github.com/rust-lang-nursery/rust-bindgen;
    license = with licenses; [ bsd3 ];
    maintainers = [ maintainers.ralith ];
  };
}
