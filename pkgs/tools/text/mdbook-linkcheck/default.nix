{ lib, stdenv, fetchFromGitHub, rustPlatform, pkg-config, openssl, Security
, testers, mdbook-linkcheck }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-linkcheck";
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "Michael-F-Bryan";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ZEOuA8W05800cnArscaGGOWTgzU6V3/wJiQcSx1MVkY=";
  };

  cargoSha256 = "sha256-EtPhbKvPHSnmPXemCzOXujlqqfdDSFaJpcZVJoHQq6U=";

  buildInputs = if stdenv.isDarwin then [ Security ] else [ openssl ];

  nativeBuildInputs = lib.optionals (!stdenv.isDarwin) [ pkg-config ];

  OPENSSL_NO_VENDOR = 1;

  doCheck = false; # tries to access network to test broken web link functionality

  passthru.tests.version = testers.testVersion { package = mdbook-linkcheck; };

  meta = with lib; {
    description = "A backend for `mdbook` which will check your links for you.";
    homepage = "https://github.com/Michael-F-Bryan/mdbook-linkcheck";
    license = licenses.mit;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
