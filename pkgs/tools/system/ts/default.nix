{ lib, stdenv, fetchurl
, sendmailPath ? "/run/wrappers/bin/sendmail"
}:

stdenv.mkDerivation rec {
  pname = "ts";
  version = "1.0.2";

  installPhase=''make install "PREFIX=$out"'';

  patchPhase = ''
    sed -i s,/usr/sbin/sendmail,${sendmailPath}, mail.c ts.1
  '';

  src = fetchurl {
    url = "https://viric.name/~viric/soft/ts/ts-${version}.tar.gz";
    sha256 = "sha256-9zRSrtgOL5p3ZIg+k1Oqf0DmXTwZmtHzvmD9WLWOr+w=";
  };

  meta = with lib; {
    homepage = "http://vicerveza.homeunix.net/~viric/soft/ts";
    description = "Task spooler - batch queue";
    license = licenses.gpl2;
    maintainers = with maintainers; [ viric ];
    platforms = platforms.all;
    mainProgram = "ts";
  };
}
