{stdenv, fetchurl, python, antlr}:

stdenv.mkDerivation rec {
  name = "PyStringTemplate-${version}";
  version = "3.2b1";

  src = fetchurl {
    url = "http://www.stringtemplate.org/download/${name}.tar.gz";
    sha256 = "0lbib0l8c1q7i1j610rwcdagymr1idahrql4dkgnm5rzyg2vk3ml";
  };

  propagatedBuildInputs = [python antlr];

  dontBuild = true;

  installPhase = ''
    python setup.py install --prefix=$out --install-lib=$(toPythonPath $out) -O1
  '';

  meta = {
    homepage = "http://www.stringtemplate.org/";
    description = "Text Templating Library";
    platforms = stdenv.lib.platforms.linux;
  };
}
