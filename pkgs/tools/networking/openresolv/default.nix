{ stdenv, fetchurl, makeWrapper, coreutils }:

stdenv.mkDerivation rec {
  name = "openresolv-${version}";
  version = "3.9.0";

  src = fetchurl {
    url = "mirror://roy/openresolv/${name}.tar.xz";
    sha256 = "1f2dccc52iykbpma26fbxzga2l6g4njm3bgaxz4rgdrb4cwlv82i";
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

  installFlags = "SYSCONFDIR=$(out)/etc";

  postInstall = ''
    wrapProgram "$out/sbin/resolvconf" --set PATH "${coreutils}/bin"
  '';

  meta = {
    description = "A program to manage /etc/resolv.conf";
    homepage = http://roy.marples.name/projects/openresolv;
    license = stdenv.lib.licenses.bsd2;
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux;
  };
}
