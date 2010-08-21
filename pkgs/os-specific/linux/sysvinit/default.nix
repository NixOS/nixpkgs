{ stdenv, fetchurl, withoutInitTools ? false }:

let version = "2.88dsf"; in

stdenv.mkDerivation {
  name = (if withoutInitTools then "sysvtools" else "sysvinit") + "-" + version;
  
  src = fetchurl {
    url = "mirror://savannah/sysvinit/sysvinit-${version}.tar.bz2";
    sha256 = "068mvzaz808a673zigyaqb63xc8bndh2klk16zi5c83rw70wifv0";
  };
  
  patches = [ ./sysvinit-2.85-exec.patch ];

  makeFlags = "SULOGINLIBS=-lcrypt ROOT=$(out) MANDIR=/share/man";

  preInstall =
    ''
      substituteInPlace src/Makefile --replace /usr /
    '';

  postInstall = stdenv.lib.optionalString withoutInitTools
    ''  
      mv $out/sbin/killall5 $out/bin
      ln -sf killall5 $out/bin/pidof
      rm -rf $out/sbin
      rm -rf $out/include
      rm -rf $out/share/man/man5
      rm $(for i in $out/share/man/man8/*; do echo $i; done | grep -v 'pidof\|killall5')
    '';
    
  meta = {
    homepage = http://www.nongnu.org/sysvinit/;
    description = "Utilities related to booting and shutdown";
  };
}
