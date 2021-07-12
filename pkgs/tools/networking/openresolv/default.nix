{ lib, stdenv, fetchurl, makeWrapper, coreutils }:

stdenv.mkDerivation rec {
  pname = "openresolv";
  version = "3.12.0";

  src = fetchurl {
    url = "mirror://roy/openresolv/${pname}-${version}.tar.xz";
    sha256 = "sha256-QrMFCOhXoihTXGMeqsk2hi2G7KaMFLXAvzh7oXa5G5c=";
  };

  nativeBuildInputs = [ makeWrapper ];

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
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.eelco ];
    platforms = lib.platforms.linux;
  };
}
