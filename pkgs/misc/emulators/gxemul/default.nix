{ stdenv, composableDerivation, fetchurl }:

let edf = composableDerivation.edf;
    version = "0.6.0.1";
    name = "gxemul-${version}";
in

composableDerivation.composableDerivation {} {
  inherit name;

  src = fetchurl {
    url = "http://gxemul.sourceforge.net/src/${name}.tar.gz";
    sha256 = "1afd9l0igyv7qgc0pn3rkdgrl5d0ywlyib0qhg4li23zilyq5407";
  };

  configurePhase = "./configure";

  installPhase = "mkdir -p \$out/bin; cp gxemul \$out/bin;";

  mergeAttrBy = { installPhase = a : b : "${a}\n${b}"; };

  flags = {
    doc   = { installPhase = "mkdir -p \$out/share/${name}; cp -r doc \$out/share/${name};"; implies = "man"; };
    demos = { installPhase = "mkdir -p \$out/share/${name}; cp -r demos \$out/share/${name};"; };
    man   = { installPhase = "cp -r ./man \$out/;";};
  };

  cfg = {
    docSupport = true;
    demosSupport = true;
    manSupport = true;
  };

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
