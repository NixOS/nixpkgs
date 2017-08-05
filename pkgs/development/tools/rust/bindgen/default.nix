{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper, llvmPackages }:

# Future work: Automatically communicate NIX_CFLAGS_COMPILE to bindgen's tests and the bindgen executable itself.

rustPlatform.buildRustPackage rec {
  name = "rust-bindgen-${version}";
  version = "0.30.0";

  src = fetchFromGitHub {
    owner = "rust-lang-nursery";
    repo = "rust-bindgen";
    rev = "v${version}";
    sha256 = "02ic48qng76rvwa54i8zkvqgr8kfsyj3axc08naylzcvwzp84bsf";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ llvmPackages.clang-unwrapped ];

  configurePhase = ''
    export LIBCLANG_PATH="${llvmPackages.clang-unwrapped}/lib"
  '';

  postInstall = ''
    wrapProgram $out/bin/bindgen --set LIBCLANG_PATH "${llvmPackages.clang-unwrapped}/lib"
  '';

  cargoSha256 = "128skg31lc9v8i7ghfb3wyiazivqfvzhi1mvmjcl0gkx1hi5006v";

  doCheck = false; # A test fails because it can't find standard headers in NixOS

  meta = with stdenv.lib; {
    description = "C and C++ binding generator";
    homepage = https://github.com/rust-lang-nursery/rust-bindgen;
    license = with licenses; [ bsd3 ];
    maintainers = [ maintainers.ralith ];
  };
}
