{ stdenv, fetchurl, makeWrapper, coreutils }:

stdenv.mkDerivation rec {
  pname = "openresolv";
  version = "3.11.0";

  src = fetchurl {
    url = "mirror://roy/openresolv/${pname}-${version}.tar.xz";
    sha256 = "0g7wb2880hbr0x99n73m7fgjm7lcdbpxfy2i620zxcq73qfrvspa";
  };

  buildInputs = [ makeWrapper ];

  configurePhase =
    ''
      cat > config.mk <<EOF
      PREFIX=$out
      SYSCONFDIR=/etc
      SBINDIR=$out/sbin
      LIBEXECDIR=$out/libexec/resolvconf
      VARDIR=/run/resolvconf
      MANDIR=$out/share/man
      RESTARTCMD=false
      EOF
    '';

  installFlags = [ "SYSCONFDIR=$(out)/etc" ];

  postInstall = ''
    wrapProgram "$out/sbin/resolvconf" --set PATH "${coreutils}/bin"
  '';

  meta = {
    description = "A program to manage /etc/resolv.conf";
    homepage = "https://roy.marples.name/projects/openresolv";
    license = stdenv.lib.licenses.bsd2;
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux;
  };
}
