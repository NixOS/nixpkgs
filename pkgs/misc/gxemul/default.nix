{ composableDerivation, fetchurl }:

let edf = composableDerivation.edf;
    name = "gxemul-0.4.6";
in

composableDerivation.composableDerivation {} {
  inherit name;
  
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

  installPhase = "mkdir -p \$out/bin; cp gxemul \$out/bin;";

  src = fetchurl {
    url = http://gavare.se/gxemul/src/gxemul-0.4.6.tar.gz;
    sha256 = "0hf3gi6hfd2qr5090zimfiddcjgank2q6m7dfsr81wwpxfbhb2z3";
  };

  configurePhase = "./configure";

  meta = {
    license = "BSD";
    description = "A Machine Emulator, mainly emulates MIPS, but supports other CPU types";
    homepage = http://gavare.se/gxemul/;
  };

  mergeAttrBy = { installPhase = a : b : "${a}\n${b}"; };
}
