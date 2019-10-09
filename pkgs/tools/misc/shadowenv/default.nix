{ stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "shadowenv";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = pname;
    rev = version;
    sha256 = "01hhh45h742z9mjcpmyjpbjf90a5b1m58b6nml2han149xpn5b74";
  };

  cargoSha256 = "0r8s20xgcp5d1ac07g5g4lrrnhrn2qsr1kgj13h2csly22j0ca2a";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  meta = with stdenv.lib; {
    homepage = "https://shopify.github.io/shadowenv/";
    description = "reversible directory-local environment variable manipulations";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
