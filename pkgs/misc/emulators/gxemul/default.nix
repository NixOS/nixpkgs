{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "gxemul";
  version = "0.6.0.1";

  src = fetchurl {
    url = "http://gxemul.sourceforge.net/src/${pname}-${version}.tar.gz";
    sha256 = "1afd9l0igyv7qgc0pn3rkdgrl5d0ywlyib0qhg4li23zilyq5407";
  };

  configurePhase = "./configure";

  installPhase = ''
    mkdir -p $out/bin;
    mkdir -p $out/share/${pname}-${version};
    cp gxemul $out/bin;
    cp -r doc $out/share/${pname}-${version};
    cp -r demos $out/share/${pname}-${version};
    cp -r ./man $out/;
  '';

  meta = {
    license = stdenv.lib.licenses.bsd3;
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
    homepage = http://gxemul.sourceforge.net/;
  };
}
