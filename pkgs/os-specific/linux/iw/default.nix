{stdenv, fetchurl, libnl, pkgconfig}:

stdenv.mkDerivation {
  name = "iw-3.6";

  src = fetchurl {
    url = http://wireless.kernel.org/download/iw/iw-3.6.tar.bz2;
    sha256 = "0my8nv6liya0b15nqn8wq2kxwjy7x6k65a9x1121zwqxq5m064fz";
  };

  buildInputs = [ libnl pkgconfig ];

  preBuild = "
    makeFlagsArray=(PREFIX=$out)
  ";

  meta = {
    description = "Tool to use nl80211";
    homepage = http://wireless.kernel.org/en/users/Documentation/iw;
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
