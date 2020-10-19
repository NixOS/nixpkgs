{ fetchFromGitHub, rustPlatform, stdenv, fetchpatch
, CoreFoundation, libiconv, libresolv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "onefetch";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "o2sh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-F1NbzcMoct0mjWKY2itz4cBqVToY7HpoaRzk3l683fY=";
  };

  cargoSha256 = "sha256-eBY+34VEPEAv5bqerxR3i7cJrVb1GtvmWyrM7uuef2E=";

  buildInputs = with stdenv;
    lib.optionals isDarwin [ CoreFoundation libiconv libresolv Security ];

  meta = with stdenv.lib; {
    description = "Git repository summary on your terminal";
    homepage = "https://github.com/o2sh/onefetch";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
  };
}
