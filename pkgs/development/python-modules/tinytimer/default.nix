{ python, stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  version = "0.0.0";
  pname = "tinytimer";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6ad13c8f01ab6094e58081a5367ffc4c5831f2d6b29034d2434d8ae106308fa5";
  };

  checkInputs = [ ];
  propagatedBuildInputs = [ ];

  checkPhase = ''
    ${python.interpreter} -c 'import tinytimer'
  '';

  # Tests require extra dependencies
  doCheck = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/iskandr/tinytimer";
    description = "Tiny Python benchmarking library";
    license = licenses.asl20;
  };
}
