{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "pmd-4.2.5";
  buildInputs = [unzip] ;

  src = fetchurl {
    url = mirror://sourceforge/pmd/pmd-bin-4.2.5.zip ;
    sha256 = "07cb18mv7rplksy3iw3rxyjaav4m7kcjqfhzv20ki73hfkqxa85c";
  };

  installPhase = ''
    mkdir -p $out
    cp -R * $out
  '';

  meta = {
    description = "PMD scans Java source code and looks for potential problems." ;
    homepage = http://pmd.sourceforge.net/;
  };
}

