{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "jdepend-2.9";
  buildInputs = [unzip] ;

  src = fetchurl {
    url = http://www.clarkware.com/software/jdepend-2.9.zip ;
    sha256 = "1915fk9w9mjv9i6hlkn2grv2kjqcgn4xa8278v66f1ix5wpfcb90";
  };

  installPhase = ''
    mkdir -p $out
    cp -R * $out
  '';

  meta = {
    description = "Depend traverses Java class file directories and generates design quality metrics for each Java package." ;
    homepage = http://www.clarkware.com/software/JDepend.html ;
  };
}



