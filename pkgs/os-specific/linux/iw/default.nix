{stdenv, fetchurl, libnl, pkgconfig}:

stdenv.mkDerivation rec {
  name = "iw-3.15";

  src = fetchurl {
    url = "https://www.kernel.org/pub/software/network/iw/${name}.tar.xz";
    sha256 = "12jby9nv5nypadgdksbqw0y2kfm3j47zw7a3rwmy56d7rs90lp5x";
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
