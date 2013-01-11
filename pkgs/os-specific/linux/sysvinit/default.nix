{ stdenv, fetchurl, withoutInitTools ? false }:

let version = "2.88dsf"; in

stdenv.mkDerivation {
  name = (if withoutInitTools then "sysvtools" else "sysvinit") + "-" + version;

  src = fetchurl {
    url = "mirror://savannah/sysvinit/sysvinit-${version}.tar.bz2";
    sha256 = "068mvzaz808a673zigyaqb63xc8bndh2klk16zi5c83rw70wifv0";
  };

  prePatch = ''
    # Patch some minimal hard references, so halt/shutdown work
    sed -i -e "s,/sbin/,$out/sbin/," src/halt.c src/init.c src/paths.h
  '';

  makeFlags = "SULOGINLIBS=-lcrypt ROOT=$(out) MANDIR=/share/man";

  crossAttrs = {
    makeFlags = "SULOGINLIBS=-lcrypt ROOT=$(out) MANDIR=/share/man CC=${stdenv.cross.config}-gcc";
  };

  preInstall =
    ''
      substituteInPlace src/Makefile --replace /usr /
    '';

  postInstall = stdenv.lib.optionalString withoutInitTools
    ''
      mv $out/sbin/killall5 $out/bin
      ln -sf killall5 $out/bin/pidof
      shopt -s extglob
      rm -rf $out/sbin/!(sulogin)
      rm -rf $out/include
      rm -rf $out/share/man/man5
      rm $(for i in $out/share/man/man8/*; do echo $i; done | grep -v 'pidof\|killall5')
      rm $out/bin/{mountpoint,wall} $out/share/man/man1/{mountpoint.1,wall.1}
    '';

  meta = {
    homepage = http://www.nongnu.org/sysvinit/;
    description = "Utilities related to booting and shutdown";
  };
}
