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
  version = "2.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0l3pih5ca469v7if255h5rqymirsw46bi6s7p885jxhq1gv6cfpk";
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
    homepage = "https://github.com/agronholm/typeguard";
    license = licenses.mit;
  };
}
