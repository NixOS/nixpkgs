{ buildPythonPackage
, fetchPypi
, pythonOlder
, stdenv
, setuptools_scm
, pytest
}:

buildPythonPackage rec {
  pname = "typeguard";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e588ff78b7093fc31c3b00c78db09b9b3764157b03b867f25ccd1dd3efd96ffb";
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
