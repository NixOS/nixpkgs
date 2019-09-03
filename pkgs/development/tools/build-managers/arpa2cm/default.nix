{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "arpa2cm";
  version = "0.5";

  src = fetchFromGitHub {
    sha256 = "093h7njj8d8iiwnw5byfxkkzlbny60fwv1w57j8f1lsd4yn6rih4";
    rev = "version-${version}";
    repo = "${pname}";
    owner = "arpa2";
  };

  buildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "CMake Module library for the ARPA2 project";
    license = licenses.bsd2;
    maintainers = with maintainers; [ leenaars ];
  };
}
