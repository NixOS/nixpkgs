{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "clamsmtp";
  version = "1.10";

  src = fetchurl {
    url = "http://thewalter.net/stef/software/clamsmtp/${pname}-${version}.tar.gz";
    sha256 = "0apr1pxifw6f1rbbsdrrwzs1dnhybg4hda3qqhqcw7p14r5xnbx5";
  };

  patches = [ ./header-order.patch ];

  meta = with lib; {
    description = "SMTP filter that allows to check for viruses using the ClamAV
                   anti-virus software";
    homepage = "http://thewalter.net/stef/software/clamsmtp/";
    license = licenses.bsd3;
    maintainers = [ maintainers.ekleog ];
    mainProgram = "clamsmtpd";
    platforms = platforms.all;
  };
}
