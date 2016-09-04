{stdenv, fetchurl, yacc}:

let
  bindir = if stdenv.system == "i686-linux" then "bin.linuxx86"
    else if stdenv.system == "x86_64-linux" then "bin.linux"
    else throw "Unsupported platform by now";
in

stdenv.mkDerivation {
  name = "jam-2.5";
  src = fetchurl {
    url = ftp://ftp.perforce.com/jam/jam-2.5.tar;
    sha256 = "04c6khd7gdkqkvx4h3nbz99lyz7waid4fd221hq5chcygyx1sj3i";
  };

  buildInputs = [ yacc ];

  installPhase = ''
    mkdir -p $out/bin
    cp ${bindir}/jam $out/bin
  '';

  meta = {
    homepage = http://public.perforce.com/wiki/Jam;
    license = stdenv.lib.licenses.free;
    description = "Just Another Make";
    platforms = stdenv.lib.platforms.linux;
  };
}
