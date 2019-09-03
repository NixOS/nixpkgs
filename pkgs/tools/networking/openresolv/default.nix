{ stdenv, fetchurl, makeWrapper, coreutils }:

stdenv.mkDerivation rec {
  pname = "openresolv";
  version = "3.9.1";

  src = fetchurl {
    url = "mirror://roy/openresolv/${pname}-${version}.tar.xz";
    sha256 = "1wlzi88837rf4ygswmzpbcmgkbbjhn5n322n9q6ir6x367hygf1q";
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
    homepage = https://roy.marples.name/projects/openresolv;
    license = stdenv.lib.licenses.bsd2;
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux;
  };
}
