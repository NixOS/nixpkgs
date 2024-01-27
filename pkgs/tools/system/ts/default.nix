{ lib, stdenv, fetchurl
, sendmailPath ? "/run/wrappers/bin/sendmail"
}:

stdenv.mkDerivation rec {
  pname = "ts";
  version = "1.0";

  installPhase=''make install "PREFIX=$out"'';

  patchPhase = ''
    sed -i s,/usr/sbin/sendmail,${sendmailPath}, mail.c ts.1
  '';

  src = fetchurl {
    url = "https://viric.name/~viric/soft/ts/ts-${version}.tar.gz";
    sha256 = "15dkzczx10fhl0zs9bmcgkxfbwq2znc7bpscljm4rchbzx7y6lsg";
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
