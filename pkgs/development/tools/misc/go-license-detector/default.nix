{ stdenv, buildGoModule, fetchFromGitHub, Security }:

buildGoModule rec {
  pname = "go-license-detector";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "src-d";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ln1z3y9q5igf9djkxw05ql2hb1ijcvvz0mrbwz11cdv9xrsa4z4";
  };

  modSha256 = "163f1kiy7kqrnaazb8ydaaiz57lv30jyjkvv6i7pczvcg9yfhmdb";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  meta = with stdenv.lib; {
    description = "Reliable project licenses detector";
    homepage = "https://github.com/src-d/go-license-detector";
    license = licenses.asl20;
    maintainers = with maintainers; [ dtzWill ];
  };
}
