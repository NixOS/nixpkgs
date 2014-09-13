{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "pmd-4.2.6";
  buildInputs = [unzip] ;

  src = fetchurl {
    url = mirror://sourceforge/pmd/pmd-bin-4.2.6.zip ;
    sha256 = "0gg1px2jmqn09f5vjzgy9gck37qjm9p2d7gf9grsmrr2xncbipp8";
  };

  installPhase = ''
    mkdir -p $out
    cp -R * $out
  '';

  meta = {
    description = "Scans Java source code and looks for potential problems";
    homepage = http://pmd.sourceforge.net/;
  };
}

