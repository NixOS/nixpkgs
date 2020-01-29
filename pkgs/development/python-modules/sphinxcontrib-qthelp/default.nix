{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-qthelp";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "79465ce11ae5694ff165becda529a600c754f4bc459778778c7017374d4d406f";
  };


  # Check is disabled due to circular dependency of sphinx
  doCheck = false;

  meta = with stdenv.lib; {
    description = "sphinxcontrib-qthelp is a sphinx extension which outputs QtHelp document.";
    homepage = http://sphinx-doc.org/;
    license = licenses.bsd0;
  };

}
