{stdenv, fetchurl, libnl, pkgconfig}:

stdenv.mkDerivation rec {
  pname = "iw";
  version = "5.0";

  src = fetchurl {
    url = "https://www.kernel.org/pub/software/network/${pname}/${pname}-${version}.tar.xz";
    sha256 = "1ydgdsf3iycg3mx96aygwa7gcfddi5srxinlws5yxsa2rllnq5y7";
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
