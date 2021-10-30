{ lib, stdenv, fetchFromGitHub, cmake, libphonenumber, icu, protobuf }:

stdenv.mkDerivation rec {
  pname = "pn";
  version = "unstable-2021-01-28";

  src = fetchFromGitHub {
    owner = "Orange-OpenSource";
    repo = pname;
    rev = "41e1215397129ed0d42b5f137fb35b5e0648edda";
    sha256 = "1g8r7y230k01ghraa55g1bhz3fiz6bjdgcsddy2dfa5ih8c4s3jm";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libphonenumber icu protobuf ];

  meta = with lib; {
    description = "A libphonenumber command-line wrapper";
    homepage = "https://github.com/Orange-OpenSource/pn";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = [ maintainers.McSinyx ];
  };
}
