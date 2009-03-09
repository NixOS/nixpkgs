{stdenv, fetchurl, python}:

stdenv.mkDerivation rec {
  name = "PyStringTemplate-${version}";
  version = "3.2b1";
  meta = {
    homepage = "http://www.stringtemplate.org/";
    description = "Text Templating Library";
  };
  src = fetchurl {
    url = "http://www.stringtemplate.org/download/${name}.tar.gz";
    sha256 = "0lbib0l8c1q7i1j610rwcdagymr1idahrql4dkgnm5rzyg2vk3ml";
  };
  propagatedBuildInputs = [python];
  buildPhase = "true";
  installPhase = "python setup.py install --prefix=$out --install-lib=$(toPythonPath $out) -O1";
}
