{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper, llvmPackages }:

# Future work: Automatically communicate NIX_CFLAGS_COMPILE to bindgen's tests and the bindgen executable itself.

rustPlatform.buildRustPackage rec {
  name = "rust-bindgen-${version}";
  version = "0.26.1";

  src = fetchFromGitHub {
    owner = "servo";
    repo = "rust-bindgen";
    rev = "v${version}";
    sha256 = "1w1vbfhmcrcl0vacxkivmavjp51cvpyq5lk75n9zs80q5x38ypna";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ llvmPackages.clang-unwrapped ];

  configurePhase = ''
    export LIBCLANG_PATH="${llvmPackages.clang-unwrapped}/lib"
  '';

  postInstall = ''
    wrapProgram $out/bin/bindgen --set LIBCLANG_PATH "${llvmPackages.clang-unwrapped}/lib"
  '';

  depsSha256 = "0s1x4ygjwc14fbl2amz5g6n7lq07zy8b00mvwfw6vi6k4bq1g59i";

  doCheck = false; # A test fails because it can't find standard headers in NixOS

  meta = with stdenv.lib; {
    description = "C binding generator";
    homepage = https://github.com/servo/rust-bindgen;
    license = with licenses; [ bsd3 ];
    maintainers = [ maintainers.ralith ];
  };
}
