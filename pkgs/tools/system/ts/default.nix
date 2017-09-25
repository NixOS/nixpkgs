{ stdenv, fetchurl
, sendmailPath ? "/run/wrappers/bin/sendmail"
}:

stdenv.mkDerivation rec {

  name = "ts-0.7.6";

  installPhase=''make install "PREFIX=$out"'';

  patchPhase = ''
    sed -i s,/usr/sbin/sendmail,${sendmailPath}, mail.c ts.1
  '';

  src = fetchurl {
    url = "http://viric.name/~viric/soft/ts/${name}.tar.gz";
    sha256 = "07b61sx3hqpdxlg5a1xrz9sxww9yqdix3bmr0sm917r3rzk87lwk";
  };

  meta = with stdenv.lib; {
    homepage = http://vicerveza.homeunix.net/~viric/soft/ts;
    description = "Task spooler - batch queue";
    license = licenses.gpl2;
    maintainers = with maintainers; [ viric ];
    platforms = platforms.all;
  };
}
