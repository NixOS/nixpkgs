{ stdenv, fetchFromGitHub, rustPlatform, llvmPackages }:

with rustPlatform;

# Future work: Automatically communicate NIX_CFLAGS_COMPILE to bindgen's tests and the bindgen executable itself.

buildRustPackage rec {
  name = "rust-bindgen-${version}";
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = "Yamakaky";
    repo = "rust-bindgen";
    rev = "${version}";
    sha256 = "0pv1vcgp455hys8hb0yj4vrh2k01zysayswkasxq4hca8s2p7qj9";
  };

  buildInputs = [ llvmPackages.clang-unwrapped ];

  configurePhase = ''
    export LIBCLANG_PATH="${llvmPackages.clang-unwrapped}/lib"
  '';

  depsSha256 = "0rlmdiqjg9ha9yzhcy33abvhrck6sphczc2gbab9zhfa95gxprv8";

  doCheck = false; # A test fails because it can't find standard headers in NixOS

  meta = with stdenv.lib; {
    description = "C binding generator";
    homepage = https://github.com/Yamakaky/rust-bindgen;
    license = with licenses; [ bsd3 ];
    maintainers = [ maintainers.ralith ];
  };
}
