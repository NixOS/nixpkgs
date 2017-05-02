{ stdenv, fetchFromGitHub, rustPlatform, llvmPackages }:

# Future work: Automatically communicate NIX_CFLAGS_COMPILE to bindgen's tests and the bindgen executable itself.

rustPlatform.buildRustPackage rec {
  name = "rust-bindgen-${version}";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "servo";
    repo = "rust-bindgen";
    rev = "v${version}";
    sha256 = "1cr7wgb13pavjpv2glq02wf5sqigcl1k0qgf3cqi9c5mjca2cg5y";
  };

  buildInputs = [ llvmPackages.clang-unwrapped ];

  configurePhase = ''
    export LIBCLANG_PATH="${llvmPackages.clang-unwrapped}/lib"
  '';

  depsSha256 = "1qrnd9a73vxr7572byjjlhwbax3z4slc7qmwjx3aiwjix3r250dh";

  doCheck = false; # A test fails because it can't find standard headers in NixOS

  meta = with stdenv.lib; {
    description = "C binding generator";
    homepage = https://github.com/servo/rust-bindgen;
    license = with licenses; [ bsd3 ];
    maintainers = [ maintainers.ralith ];
  };
}
