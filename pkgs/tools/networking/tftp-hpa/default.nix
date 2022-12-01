{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "tftp-hpa";
  version="5.2";
  src = fetchurl {
    url = "mirror://kernel/software/network/tftp/tftp-hpa/${pname}-${version}.tar.xz";
    sha256 = "12vidchglhyc20znq5wdsbhi9mqg90jnl7qr9qs8hbvaz4fkdvmg";
  };

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: main.o:/build/tftp-hpa-5.2/tftp/main.c:98: multiple definition of
  #     `toplevel'; tftp.o:/build/tftp-hpa-5.2/tftp/tftp.c:51: first defined here
  NIX_CFLAGS_COMPILE="-fcommon";

  meta = with lib; {
    description = "TFTP tools - a lot of fixes on top of BSD TFTP";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    license = licenses.bsd3;
    homepage = "https://www.kernel.org/pub/software/network/tftp/";
  };

  passthru = {
    updateInfo = {
      downloadPage = "https://www.kernel.org/pub/software/network/tftp/";
    };
  };
}
