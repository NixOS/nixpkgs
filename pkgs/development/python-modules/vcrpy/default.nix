{ buildPythonPackage
, lib
, six
, fetchPypi
, pyyaml
, mock
, contextlib2
, wrapt
, pytest
, pytest-httpbin
, yarl
, pythonOlder
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "vcrpy";
  version = "1.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7031f9c78a70b9586d2db4a2ec135c4e04194cabff58695ef0cc95e7cd66bc01";
  };

  checkInputs = [
    pytest
    pytest-httpbin
  ];

  propagatedBuildInputs = [
    pyyaml
    wrapt
    six
  ]
  ++ lib.optionals (pythonOlder "3.3") [ contextlib2 mock ]
  ++ lib.optionals (pythonAtLeast "3.4") [ yarl ];

  checkPhase = ''
    py.test --ignore=tests/integration -k "not TestVCRConnection"
  '';

  meta = with lib; {
    description = "Automatically mock your HTTP interactions to simplify and speed up testing";
    homepage = https://github.com/kevin1024/vcrpy;
    license = licenses.mit;
  };
}

