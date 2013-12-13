{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "tmpwatch-2.11";

  src = fetchurl {
    url = "https://fedorahosted.org/releases/t/m/tmpwatch/tmpwatch-2.11.tar.bz2";
    sha256 = "1m5859ngwx61l1i4s6fja2avf1hyv6w170by273w8nsin89825lk";
  };

  meta = {
    homepage = https://fedorahosted.org/tmpwatch/;
    description = "The tmpwatch utility recursively searches through specified directories and removes files which have not been accessed in a specified period of time.";
    licence = "GPLv2";
    maintainers = with stdenv.lib.maintainers; [ vlstill ];
  };
}
