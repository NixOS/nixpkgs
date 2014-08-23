{stdenv, fetchurl,
sendmailPath ? "/var/setuid-wrappers/sendmail" }:

stdenv.mkDerivation rec {

  name = "ts-0.7.4";

  installPhase=''make install "PREFIX=$out"'';

  crossAttrs = {
    makeFlags = "CC=${stdenv.cross.config}-gcc";
  };

  patchPhase = ''
    sed -i s,/usr/sbin/sendmail,${sendmailPath}, mail.c ts.1
  '';

  src = fetchurl {
    url = "http://viric.name/~viric/soft/ts/${name}.tar.gz";
    sha256 = "042r9a09300v4fdrw4r60g5xi25v5m6g12kvvr6pcsm9qnfqyqqs";
  };

  meta = {
    homepage = "http://vicerveza.homeunix.net/~viric/soft/ts";
    description = "task spooler - batch queue";
    license="GPLv2";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}
