{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "openresolv-3.4.6";

  src = fetchurl {
    url = "http://roy.marples.name/downloads/openresolv/${name}.tar.bz2";
    sha256 = "026z4973b0vqp5acr6mn5fyxyc84y4ahg1f8fddh8dph86jcnhba";
  };

  configurePhase =
    ''
      cat > config.mk <<EOF
      PREFIX=$out
      SYSCONFDIR=/etc
      SBINDIR=$out/sbin
      LIBEXECDIR=$out/libexec/resolvconf
      VARDIR=/var/run/resolvconf
      MANDIR=$out/share/man
      RESTARTCMD="false \1"
      EOF
    '';

  installFlags = "SYSCONFDIR=$(out)/etc";

  meta = { 
    description = "A program to manage /etc/resolv.conf";
    homepage = http://roy.marples.name/projects/openresolv;
    license = "bsd";
  };
}
