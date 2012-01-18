{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "checkstyle-5.0";
  buildInputs = [unzip] ; 

  src = fetchurl {
    url = mirror://sourceforge/checkstyle/checkstyle-5.0.zip ;
    sha256 = "0972afcxjniz64hlnc89ddnd1d0mcd5hb1sd7lpw5k52h39683nh";
  };

  installPhase = ''
    mkdir -p $out/checkstyle
    cp -R * $out/checkstyle
  '';

  meta = {
    description = "A development tool to help programmers write Java code that adheres to a coding standard. By default it supports the Sun Code Conventions, but is highly configurable." ;
    homepage = http://checkstyle.sourceforge.net/;
  };
}

