{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "cabextract-1.7";

  src = fetchurl {
    url = "https://www.cabextract.org.uk/${name}.tar.gz";
    sha256 = "1g86wmb8lkjiv2jarfz979ngbgg7d3si8x5il4g801604v406wi9";
  };

  meta = with stdenv.lib; {
    homepage = https://www.cabextract.org.uk/;
    description = "Free Software for extracting Microsoft cabinet files";
    platforms = platforms.all;
    license = licenses.gpl3;
    maintainers = with maintainers; [ pSub ];
  };
}
