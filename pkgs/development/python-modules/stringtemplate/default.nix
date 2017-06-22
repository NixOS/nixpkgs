{stdenv, fetchurl, buildPythonPackage, antlr, isPy3k}:

buildPythonPackage rec {
  pname = "PyStringTemplate";
  name = "${pname}-${version}";
  version = "3.2b1";

  src = fetchurl {
    url = "http://www.stringtemplate.org/download/${name}.tar.gz";
    sha256 = "0lbib0l8c1q7i1j610rwcdagymr1idahrql4dkgnm5rzyg2vk3ml";
  };

  propagatedBuildInputs = [ antlr ];

  disabled = isPy3k;

  # No tests included in archive
  doCheck = false;

  meta = {
    homepage = "http://www.stringtemplate.org/";
    description = "Text Templating Library";
    platforms = stdenv.lib.platforms.linux;
  };
}
