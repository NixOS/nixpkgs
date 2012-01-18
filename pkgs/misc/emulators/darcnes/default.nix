{stdenv, fetchurl, libX11, libXt, libXext, libXaw }:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation { 
  name = "darcnes-9b0401";
  src = fetchurl {
    url = http://www.dridus.com/~nyef/darcnes/download/dn9b0401.tgz;
    sha256 = "05a7mh51rg7ydb414m3p5mm05p4nz2bgvspqzwm3bhbj7zz543k3";
  };

  buildInputs = [ libX11 libXt libXext libXaw ];

  installPhase = ''
    mkdir -p $out/bin
    cp darcnes $out/bin
  '';

  patches = [ ./label.patch ];

  meta = {
    homepage = http://www.dridus.com/~nyef/darcnes/;
    description = "Multi-System emulator, specially for NES";
    /* Prohibited commercial use, credit required. */
    license = "free";
  };

}
