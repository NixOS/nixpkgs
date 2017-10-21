{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "kzipmix-20091108";

  src = fetchurl {
    url = http://static.jonof.id.au/dl/kenutils/kzipmix-20091108-linux.tar.gz;
    sha256 = "19gyn8pblffdz1bf3xkbpzx8a8wn3xb0v411pqzmz5g5l6pm5gph";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp kzip zipmix $out/bin
    
    patchelf --set-interpreter ${stdenv.glibc.out}/lib/ld-linux.so.2 $out/bin/kzip
    patchelf --set-interpreter ${stdenv.glibc.out}/lib/ld-linux.so.2 $out/bin/zipmix
  '';

  meta = {
    description = "A tool that aggressively optimizes the sizes of Zip archives";
    license = stdenv.lib.licenses.unfree;
    homepage = http://advsys.net/ken/utils.htm;
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
