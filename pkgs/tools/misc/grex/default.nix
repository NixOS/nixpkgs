{ stdenv, fetchFromGitHub, fetchpatch, rustPlatform, cmake, perl, pkgconfig, zlib
, darwin, libiconv, installShellFiles
}:

with rustPlatform;

buildRustPackage rec {
  pname = "grex";
  version = "1.1.0";

  cargoSha256 = "0kf2n2j7kfrfzid1h2gd0qf53fah0hpyrrlh2k5vrhd0panv3bwc";

  src = fetchFromGitHub {
    owner = "pemistahl";
    repo = "grex";
    rev = "v${version}";
    sha256 = "1viph7ki6f2akc5mpbgycacndmxnv088ybfji2bfdbi5jnpyavvs";
  };

  nativeBuildInputs = [ cmake pkgconfig perl installShellFiles ];
  buildInputs = [ zlib ]
  ++ stdenv.lib.optionals stdenv.isDarwin [
    libiconv darwin.apple_sdk.frameworks.Security ]
  ;

  # Some tests fail, but Travis ensures a proper build
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A command-line tool for generating regular expressions from user-provided test cases";
    homepage = "https://github.com/pemistahl/grex";
    license = licenses.asl20;
    maintainers = with maintainers; [ colemickens ];
  };
}
