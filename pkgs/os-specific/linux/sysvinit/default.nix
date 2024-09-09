{ lib, stdenv, fetchurl, libxcrypt, withoutInitTools ? false }:

stdenv.mkDerivation rec {
  pname = if withoutInitTools then "sysvtools" else "sysvinit";
  version = "3.04";

  src = fetchurl {
    url = "mirror://savannah/sysvinit/sysvinit-${version}.tar.xz";
    sha256 = "sha256-KmIf5uRSi8kTCLdIZ92q6733dT8COVwMW66Be9K346U=";
  };

  prePatch = ''
    # Patch some minimal hard references, so halt/shutdown work
    sed -i -e "s,/sbin/,$out/sbin/," src/halt.c src/init.c src/paths.h
  '';

  buildInputs = [ libxcrypt ];

  makeFlags = [ "SULOGINLIBS=-lcrypt" "ROOT=$(out)" "MANDIR=/share/man" ];

  preInstall =
    ''
      substituteInPlace src/Makefile --replace /usr /
    '';

  postInstall = ''
    mv $out/sbin/killall5 $out/bin
    ln -sf killall5 $out/bin/pidof
  ''
    + lib.optionalString withoutInitTools
    ''
      shopt -s extglob
      rm -rf $out/sbin/!(sulogin)
      rm -rf $out/include
      rm -rf $out/share/man/man5
      rm $(for i in $out/share/man/man8/*; do echo $i; done | grep -v 'pidof\|killall5')
      rm $out/bin/wall $out/share/man/man1/wall.1
    '';

  meta = {
    homepage = "https://www.nongnu.org/sysvinit/";
    description = "Utilities related to booting and shutdown";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
  };
}
