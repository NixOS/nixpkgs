{ stdenv
, buildPythonPackage
, fetchPypi
, setuptools
, pyparsing
, pytest
}:

buildPythonPackage rec {
  pname = "svgwrite";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "11e47749b159ed7004721e11d380b4642a26154b8cb2f7b0102fea9c71a3dfa1";
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
