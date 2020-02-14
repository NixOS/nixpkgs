{ stdenv, fetchurl, psmisc }:

stdenv.mkDerivation {
  name = "tmpwatch-2.11";

  src = fetchurl {
    url = "https://fedorahosted.org/releases/t/m/tmpwatch/tmpwatch-2.11.tar.bz2";
    sha256 = "1m5859ngwx61l1i4s6fja2avf1hyv6w170by273w8nsin89825lk";
  };

  configureFlags = [ "--with-fuser=${psmisc}/bin/fuser" ];

  meta = with stdenv.lib; {
    homepage = https://fedorahosted.org/tmpwatch/;
    description = "Recursively searches through specified directories and removes files which have not been accessed in a specified period of time";
    license = licenses.gpl2;
    maintainers = with maintainers; [ vlstill ];
    platforms = platforms.unix;
  };
}
