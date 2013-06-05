{stdenv, fetchurl, libnl, pkgconfig}:

stdenv.mkDerivation rec {
  name = "iw-3.10";

  src = fetchurl {
    url = "https://www.kernel.org/pub/software/network/iw/${name}.tar.xz";
    sha256 = "1sagsrl2s0d3ar3q2yc5qxk2d47zgn551akwcs9f4a5prw9f4vj5";
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
