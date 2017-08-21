{ stdenv, fetchurl, tcp_wrappers }:

stdenv.mkDerivation rec {
  name = "tftp-hpa-${version}";
  version="5.2";
  src = fetchurl {
    url = "mirror://kernel/software/network/tftp/tftp-hpa/${name}.tar.xz";
    sha256 = "12vidchglhyc20znq5wdsbhi9mqg90jnl7qr9qs8hbvaz4fkdvmg";
  };

  meta = with stdenv.lib; {
    description = "TFTP tools - a lot of fixes on top of BSD TFTP";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    license = licenses.bsd3;
    homepage = https://www.kernel.org/pub/software/network/tftp/;
  };

  passthru = {
    updateInfo = {
      downloadPage = "https://www.kernel.org/pub/software/network/tftp/";
    };
  };
}
