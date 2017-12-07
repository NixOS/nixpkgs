{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "cabextract-1.6";

  src = fetchurl {
    url = "http://www.cabextract.org.uk/${name}.tar.gz";
    sha256 = "1ysmmz25fjghq7mxb2anyyvr1ljxqxzi4piwjhk0sdamcnsn3rnf";
  };

  meta = with stdenv.lib; {
    homepage = https://www.cabextract.org.uk/;
    description = "Free Software for extracting Microsoft cabinet files";
    platforms = platforms.all;
    license = licenses.gpl3;
    maintainers = with maintainers; [ pSub ];
  };
}
