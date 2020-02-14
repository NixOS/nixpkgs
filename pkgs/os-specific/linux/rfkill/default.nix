{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "rfkill-0.5";

  src = fetchurl {
    url = "mirror://kernel/software/network/rfkill/${name}.tar.bz2";
    sha256 = "01zs7p9kd92pxgcgwl5w46h3iyx4acfg6m1j5fgnflsaa350q5iy";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = http://wireless.kernel.org/en/users/Documentation/rfkill;
    description = "A tool to query, enable and disable wireless devices";
    platforms = platforms.linux;
    maintainers = [ maintainers.eelco ];
    license = licenses.isc;
  };
}
