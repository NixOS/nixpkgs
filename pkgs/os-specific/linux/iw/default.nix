{ stdenv, fetchurl, pkgconfig, libnl }:

stdenv.mkDerivation rec {
  pname = "iw";
  version = "5.3";

  src = fetchurl {
    url = "https://www.kernel.org/pub/software/network/${pname}/${pname}-${version}.tar.xz";
    sha256 = "1m85ap8hwzfs7xf9r0v5d55ra4mhw45f6vclc7j6gsldpibyibq4";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libnl ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    description = "Tool to use nl80211";
    longDescription = ''
      iw is a new nl80211 based CLI configuration utility for wireless devices.
      It supports all new drivers that have been added to the kernel recently.
      The old tool iwconfig, which uses Wireless Extensions interface, is
      deprecated and it's strongly recommended to switch to iw and nl80211.
    '';
    homepage = https://wireless.wiki.kernel.org/en/users/Documentation/iw;
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ viric primeos ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
