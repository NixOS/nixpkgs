{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "ethtool";
  version = "5.2";

  src = fetchurl {
    url = "mirror://kernel/software/network/ethtool/${pname}-${version}.tar.xz";
    sha256 = "01bq2g7amycfp4syzcswz52pgphdgswklziqfjwnq3c6844dfpv6";
  };

  meta = with stdenv.lib; {
    description = "Utility for controlling network drivers and hardware";
    homepage = https://www.kernel.org/pub/software/network/ethtool/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
