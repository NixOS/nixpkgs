args: with args.lib; with args;
let
  name="gxemul-0.4.6";
  co = chooseOptionsByFlags {
    inherit args;
    flagDescr = {
      mandatory = { install = "ensureDir \$out/bin; cp gxemul \$out/bin;"; };
      doc   = { install = "ensureDir \$out/share/${name}; cp -r doc \$out/share/${name};"; implies = "man"; };
      demos = { install = "ensureDir \$out/share/${name}; cp -r demos \$out/share/${name};"; };
      man   = { install = "cp -r ./man \$out/;";};
    };
    optionals = ["libX11"];
    defaultFlags = [ "demos" "doc" ];
  };
in stdenv.mkDerivation {

  inherit name;
  inherit (co) /* flags */ buildInputs configureFlags;

  src = fetchurl {
    url = http://gavare.se/gxemul/src/gxemul-0.4.6.tar.gz;
    sha256 = "0hf3gi6hfd2qr5090zimfiddcjgank2q6m7dfsr81wwpxfbhb2z3";
  };

  configurePhase="./configure";

  installPhase = concatStrings ( catAttrs "install" co.flatOptions );

  meta = {
    license = "BSD";
    description = "A Machine Emulator, Mainly emulates MIPS, but supports other CPU type";
    homepage = http://gavare.se/gxemul/;
  };
}
