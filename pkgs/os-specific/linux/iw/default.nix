{stdenv, fetchurl, libnl, pkgconfig}:

stdenv.mkDerivation rec {
  name = "iw-4.9";

  src = fetchurl {
    url = "https://www.kernel.org/pub/software/network/iw/${name}.tar.xz";
    sha256 = "1klpvv98bnx1zm6aqalnri2vd7w80scmdaxr2qnblb6mz82whk1j";
  };

  buildInputs = [ libnl pkgconfig ];

  makeFlags = [ "PREFIX=\${out}" ];

  meta = {
    description = "Tool to use nl80211";
    homepage = http://wireless.kernel.org/en/users/Documentation/iw;
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
