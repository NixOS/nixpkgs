{stdenv, fetchurl, pythonPackages}:

pythonPackages.buildPythonApplication rec {
  name = "dtrx-${version}";
  version = "7.1";

  src = fetchurl {
    url = "http://brettcsmith.org/2007/dtrx/dtrx-${version}.tar.gz";
    sha1 = "05cfe705a04a8b84571b0a5647cd2648720791a4";
  };

  meta = with stdenv.lib; {
    description = "Do The Right Extraction: A tool for taking the hassle out of extracting archives";
    homepage = "http://brettcsmith.org/2007/dtrx/";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.spwhitt ];
    platforms = platforms.all;
  };
}
