{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "gxemul";
  version = "0.6.3";

  src = fetchurl {
    url = "http://gavare.se/gxemul/src/gxemul-${version}.tar.gz";
    sha256 = "sha256-FjYE1IiCGOX9vGhYufwewWB9AF6tvsQk86lmPh8phu0=";
  };

  configurePhase = "./configure";

  installPhase = ''
    mkdir -p {$out/bin,$out/share/${pname}-${version}}
    cp -r {doc,demos} $out/share/${pname}-${version}
    cp gxemul $out/bin
    cp -r ./man $out
  '';

  meta = with lib; {
    homepage = "http://gavare.se/gxemul/";
    description = "Gavare's experimental emulator";
    longDescription = ''
      GXemul is a framework for full-system computer architecture
      emulation. Several real machines have been implemented within the
      framework, consisting of processors (ARM, MIPS, Motorola 88K,
      PowerPC, and SuperH) and surrounding hardware components such as
      framebuffers, interrupt controllers, busses, disk controllers,
      and serial controllers. The emulation is working well enough to
      allow several unmodified "guest" operating systems to run.
    '';
    license = licenses.bsd3;
  };
}
