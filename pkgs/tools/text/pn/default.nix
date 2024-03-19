{ lib, stdenv, fetchFromGitHub, cmake, libphonenumber, icu, protobuf }:

stdenv.mkDerivation rec {
  pname = "pn";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "Orange-OpenSource";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vRF9MPcw/hCreHVLD6QB7g1r0wQiZv1xrfzIHj1Yf9M=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libphonenumber icu protobuf ];

  meta = with lib; {
    description = "A libphonenumber command-line wrapper";
    mainProgram = "pn";
    homepage = "https://github.com/Orange-OpenSource/pn";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = [ maintainers.McSinyx ];
  };
}
