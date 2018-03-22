{ buildPythonPackage
, fetchPypi
, pythonOlder
, stdenv
, setuptools_scm
, pytest
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "typeguard";
  version = "2.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "40b22d18d2215b76b3ddda2564acfbddfa6e702968637fbd969187c2a6fb99da";
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
