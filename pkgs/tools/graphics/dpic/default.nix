{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "dpic";
  version = "2020.06.01";

  src = fetchurl {
    url = "https://ece.uwaterloo.ca/~aplevich/dpic/${pname}-${version}.tar.gz";
    sha256 = "1gbkpbjwjaaifxff8amm9b47dynq4l4698snjdgnn4flndw62q88";
  };

  # The prefix passed to configure is not used.
  makeFlags = [ "DESTDIR=$(out)" ];

  meta = with stdenv.lib; {
    description = "An implementation of the pic little language for creating drawings";
    homepage = "https://ece.uwaterloo.ca/~aplevich/dpic/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ aespinosa ];
    platforms = platforms.all;
  };
}

