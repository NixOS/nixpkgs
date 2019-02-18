{ stdenv
, buildPythonPackage
, fetchPypi
, setuptools
, pyparsing
, pytest
}:

buildPythonPackage rec {
  pname = "svgwrite";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "72ef66c9fe367989823cb237ab7f012ac809dd3ba76c1b5ebd9aa61580e2e75e";
  };

  buildInputs = [ setuptools ];
  propagatedBuildInputs = [ pyparsing ];
  checkInputs = [ pytest ];

  checkPhase = ''
    pytest
  '';

  meta = with stdenv.lib; {
    description = "A Python library to create SVG drawings";
    homepage = https://github.com/mozman/svgwrite;
    license = licenses.mit;
  };

}
