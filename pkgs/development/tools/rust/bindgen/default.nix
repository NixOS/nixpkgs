{ stdenv, fetchFromGitHub, rustPlatform, llvmPackages }:

# Future work: Automatically communicate NIX_CFLAGS_COMPILE to bindgen's tests and the bindgen executable itself.

rustPlatform.buildRustPackage rec {
  name = "rust-bindgen-${version}";
  version = "0.22.1";

  src = fetchFromGitHub {
    owner = "servo";
    repo = "rust-bindgen";
    rev = "v${version}";
    sha256 = "10cavj6rrbdqi4ldfmhxy6xxp0q65pxiypdgq2ckz0c37g04qqqs";
  };

  buildInputs = [ llvmPackages.clang-unwrapped ];

  configurePhase = ''
    export LIBCLANG_PATH="${llvmPackages.clang-unwrapped}/lib"
  '';

  depsSha256 = "1gvva6f64ndzsswv1a7c31wym12yp4cg1la4zjwlzkrx62kgyk8x";

  doCheck = false; # A test fails because it can't find standard headers in NixOS

  meta = with stdenv.lib; {
    description = "C binding generator";
    homepage = https://github.com/servo/rust-bindgen;
    license = with licenses; [ bsd3 ];
    maintainers = [ maintainers.ralith ];
  };
}
