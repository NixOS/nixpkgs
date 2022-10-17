{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "kzipmix";
  version = "20200115";

  src = fetchurl {
    url = "http://static.jonof.id.au/dl/kenutils/kzipmix-${version}-linux.tar.gz";
    sha256 = "sha256-ePgye0D6/ED53zx6xffLnYhkjed7SPU4BLOZQr9E3yA=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp amd64/{kzip,zipmix} $out/bin

    patchelf --set-interpreter ${stdenv.cc.libc}/lib/ld-linux.so.2 $out/bin/kzip
    patchelf --set-interpreter ${stdenv.cc.libc}/lib/ld-linux.so.2 $out/bin/zipmix
  '';

  meta = with lib; {
    description = "A tool that aggressively optimizes the sizes of Zip archives";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    homepage = "http://advsys.net/ken/utils.htm";
    maintainers = [ maintainers.sander ];
  };
}
