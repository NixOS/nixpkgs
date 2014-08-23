{stdenv, fetchurl, libnl, pkgconfig}:

stdenv.mkDerivation rec {
  name = "iw-3.14";

  src = fetchurl {
    url = "https://www.kernel.org/pub/software/network/iw/${name}.tar.xz";
    sha256 = "16fr13cl02702d9yjqlgvnxvpv0w0mqn0acba39iwn2lln5b4747";
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
