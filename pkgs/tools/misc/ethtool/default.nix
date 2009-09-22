{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "ethtool-6";

  src = fetchurl {
    url = mirror://sourceforge/gkernel/ethtool/6/ethtool-6.tar.gz;
    sha256 = "1iml9w4lrrxsg366wzdkw1wnrydpyah0lprwqf4zcxyxwxrzaijh";
  };

}
