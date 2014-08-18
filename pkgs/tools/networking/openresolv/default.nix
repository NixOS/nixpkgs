{ stdenv, fetchurl, makeWrapper, coreutils }:

stdenv.mkDerivation rec {
  name = "openresolv-3.5.6";

  src = fetchurl {
    url = "http://roy.marples.name/downloads/openresolv/${name}.tar.bz2";
    sha256 = "1n3cw1vbm7mh5d95ykhzdn2mrrf3pm65sp61p8iwydz1gqkp2inv";
  };

  buildInputs = [ makeWrapper ];

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

  postInstall = ''
    wrapProgram "$out/sbin/resolvconf" --set PATH "${coreutils}/bin"
  '';

  meta = {
    description = "A program to manage /etc/resolv.conf";
    homepage = http://roy.marples.name/projects/openresolv;
    license = "bsd";
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux;
  };
}
