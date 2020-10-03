{ stdenv, fetchurl, pkgconfig, libnl }:

stdenv.mkDerivation rec {
  pname = "iw";
  version = "5.8";

  src = fetchurl {
    url = "https://www.kernel.org/pub/software/network/${pname}/${pname}-${version}.tar.xz";
    sha256 = "1d1dfynrzh52zdia1l23ajv4q5wixgffnc1gkz05qrxnn2n4p75m";
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
    homepage = "https://wireless.wiki.kernel.org/en/users/Documentation/iw";
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ viric primeos ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
