{ stdenv, lib, coreutils, gnused, gawk, fetchurl }:

stdenv.mkDerivation rec {
  name = "rsbep-${version}";
  version = "0.1.0";

  src = fetchurl {
    url = "https://www.thanassis.space/rsbep-0.1.0-ttsiodras.tar.bz2";
    sha256 = "1zji34kc9srxp0h1s1m7k60mvgsir1wrx1n3wc990jszfplr32zc";
  };

  postFixup = ''
    cd $out/bin

    # Move internal tool 'rsbep_chopper' to libexec
    libexecDir=$out/libexec/rsbep
    mkdir -p $libexecDir
    mv rsbep_chopper $libexecDir

    # Fix store dependencies in scripts
    path="export PATH=$out/bin:$libexecDir:${lib.makeBinPath [ coreutils gnused gawk ]}"
    sed -i "2i$path" freeze.sh
    sed -i "2i$path" melt.sh

    substituteInPlace freeze.sh --replace /bin/ls ls

    # Remove unneded binary
    rm poorZFS.py
  '';

  meta = with lib; {
    description = "Create resilient backups with Reed-Solomon error correction and byte-spreading";
    homepage = https://www.thanassis.space/rsbep.html;
    license = licenses.gpl3;
    maintainers = [ maintainers.earvstedt ];
  };
}
