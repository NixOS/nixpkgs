{ stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "shadowenv";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = pname;
    rev = version;
    sha256 = "1s59ra99wcyyqz8gzly4qmcq5rh22c50c75cdi2kyajm7ghgryy9";
  };

  cargoSha256 = "0s4p4mpz1p5v9hr4flxlzqvc1b3zbqr3nxp1nxjw39ng9g3hplpg";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  meta = with stdenv.lib; {
    homepage = "https://shopify.github.io/shadowenv/";
    description = "reversible directory-local environment variable manipulations";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
