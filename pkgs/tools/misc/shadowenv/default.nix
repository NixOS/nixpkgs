{ stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "shadowenv";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = pname;
    rev = version;
    sha256 = "1yapplqy7wmmjh8r5m43na9n2p100k80s7nkaswndyp5ljr9m20l";
  };

  cargoSha256 = "1pnfd461i65jd7s8dpfpys4k620w86bv56gkdsyx5lcvhqw1krnr";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  meta = with stdenv.lib; {
    homepage = "https://shopify.github.io/shadowenv/";
    description = "reversible directory-local environment variable manipulations";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
