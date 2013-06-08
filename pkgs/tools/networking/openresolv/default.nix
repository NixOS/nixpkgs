{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "openresolv-3.5.4";

  src = fetchurl {
    url = "http://roy.marples.name/downloads/openresolv/${name}.tar.bz2";
    sha256 = "0in40iha4ghk12lr2p65v0by3h0jp7qsdajmj4vm7iis0plzr4db";
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
