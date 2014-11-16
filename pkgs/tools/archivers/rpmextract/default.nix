{ stdenv, fetchurl, rpm, cpio, substituteAll }:

stdenv.mkDerivation rec {
  name = "rpmextract";

  buildCommand = ''
    install -Dm755 $script $out/bin/rpmextract
  '';
    
  script = substituteAll {
    src = ./rpmextract.sh;
    inherit rpm cpio;
  };

  meta = with stdenv.lib; {
    description = "Script to extract RPM archives";
    platforms = platforms.all;
    license = licenses.gpl2;
    maintainers = maintainers.abbradar;
  };
}
