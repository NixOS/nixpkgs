{stdenv, fetchurl, libnl, pkgconfig}:

stdenv.mkDerivation rec {
  name = "iw-3.11";

  src = fetchurl {
    url = "https://www.kernel.org/pub/software/network/iw/${name}.tar.xz";
    sha256 = "1zrh0pjcy0kg6n8wlr34cg3bmi3nj28rhqn5pad23a1170r2f0z9";
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
