{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "dpic";
  version = "2023.06.01";

  src = fetchurl {
    url = "https://ece.uwaterloo.ca/~aplevich/dpic/${pname}-${version}.tar.gz";
    sha256 = "sha256-7sIGSHMsxEsO9b7nutY6cBxS59mrT3bepNNDQi2L+X4=";
  };

  # The prefix passed to configure is not used.
  makeFlags = [ "DESTDIR=$(out)" ];

  meta = with lib; {
    description = "An implementation of the pic little language for creating drawings";
    homepage = "https://ece.uwaterloo.ca/~aplevich/dpic/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ aespinosa ];
    platforms = platforms.all;
    mainProgram = "dpic";
  };
}

