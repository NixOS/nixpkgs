{ stdenv
, buildPythonPackage
, fetchPypi
, setuptools
, pyparsing
}:

buildPythonPackage rec {
  pname = "svgwrite";
  version = "1.1.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1f018813072aa4d7e95e58f133acb3f68fa7de0a0d89ec9402cc38406a0ec5b8";
  };

  buildInputs = [ setuptools ];
  propagatedBuildInputs = [ pyparsing ];

  meta = with stdenv.lib; {
    description = "A Python library to create SVG drawings";
    homepage = https://bitbucket.org/mozman/svgwrite;
    license = licenses.mit;
  };

}
