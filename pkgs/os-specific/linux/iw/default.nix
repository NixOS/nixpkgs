{stdenv, fetchurl, libnl, pkgconfig}:

stdenv.mkDerivation rec {
  pname = "iw";
  version = "5.0.1";

  src = fetchurl {
    url = "https://www.kernel.org/pub/software/network/${pname}/${pname}-${version}.tar.xz";
    sha256 = "03awbfrr9i78vgwsa6z2c8g14mia9z8qzrvzxar2ad9299wylf0y";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libnl ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    description = "Tool to use nl80211";
    homepage = http://wireless.kernel.org/en/users/Documentation/iw;
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
