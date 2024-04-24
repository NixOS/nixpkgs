{ lib, stdenv, fetchurl, psmisc }:

stdenv.mkDerivation rec {
  pname = "tmpwatch";
  version = "2.11";

  src = fetchurl {
    url = "https://releases.pagure.org/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "1m5859ngwx61l1i4s6fja2avf1hyv6w170by273w8nsin89825lk";
  };

  configureFlags = [ "--with-fuser=${psmisc}/bin/fuser" ];

  meta = with lib; {
    homepage = "https://pagure.io/tmpwatch";
    description = "Recursively searches through specified directories and removes files which have not been accessed in a specified period of time";
    license = licenses.gpl2;
    maintainers = with maintainers; [ vlstill ];
    platforms = platforms.unix;
    mainProgram = "tmpwatch";
  };
}
