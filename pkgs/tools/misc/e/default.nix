{ stdenv, fetchurl }:

let
  version = "0.02718";
in
stdenv.mkDerivation {
  name = "e-${version}";
  
  src = fetchurl {
    url = "http://www.sourcefiles.org/Productivity_Tools/Calculators/e-${version}.tar.gz";
    sha256 = "1rxkb0wm136smdn0q359srvw0ppah06441rla7hy1h0k9n0bwawk";
  };

  buildInputs = [ stdenv ];

  # These morons ship a binary in their tar.gz. What the hell?
  buildPhase = ''
    rm e
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp e $out/bin
  '';

  meta = {
    homepage = "http://www.sourcefiles.org/Productivity_Tools/Calculators/e-0.02718.tar.gz.shtml";
    description = "A full arithmetic expression evaluator";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.matthiasbeyer ];
  };
}
