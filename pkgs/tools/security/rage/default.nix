{ stdenv, rustPlatform, fetchFromGitHub, Security }:

rustPlatform.buildRustPackage rec {
  pname = "rage";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "str4d";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ri4rfhy1wl0cppi2cp97kkiz08x2f072yfahn2kv9r4v1i9f4a7";
  };

  cargoSha256 = "02adwvcvha83zcvc5n7p88l7wmkg52j2xhznmhabc0zn328as2yd";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  meta = with stdenv.lib; {
    description = "A simple, secure and modern encryption tool with small explicit keys, no config options, and UNIX-style composability";
    homepage = "https://github.com/str4d/rage";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
