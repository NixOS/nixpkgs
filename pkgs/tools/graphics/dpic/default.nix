{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "dpic";
  version = "2020.09.15";

  src = fetchurl {
    url = "https://ece.uwaterloo.ca/~aplevich/dpic/${pname}-${version}.tar.gz";
    sha256 = "0gmmp4dlir3bn892nm55a3q8cfsj8yg7fp1dixmhsdhsrgmg1b83";
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

