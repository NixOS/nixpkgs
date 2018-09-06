{ buildPythonPackage
, fetchPypi
, pythonOlder
, stdenv
, setuptools_scm
, pytest
}:

buildPythonPackage rec {
  pname = "typeguard";
  version = "2.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b8ddc6e2e60bd64b7003f9a685a09ba387b74adf2f6bea7534a76d61892f573e";
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
