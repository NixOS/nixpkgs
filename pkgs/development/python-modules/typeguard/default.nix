{ buildPythonPackage
, fetchPypi
, pythonOlder
, stdenv
, setuptools_scm
, pytest
}:

buildPythonPackage rec {
  pname = "typeguard";
  version = "2.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "89159e9ab54a436db4759c32eeb0ae6e9b65cf7fe5b838daad4a658024ec3b43";
  };

  buildInputs = [ setuptools_scm ];

  postPatch = ''
    substituteInPlace setup.cfg --replace " --cov" ""
  '';

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test .
  '';

  disabled = pythonOlder "3.3";

  meta = with stdenv.lib; {
    description = "This library provides run-time type checking for functions defined with argument type annotations";
    homepage = https://github.com/agronholm/typeguard;
    license = licenses.mit;
  };
}
