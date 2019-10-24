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
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0e79239441fb4c731da9f05aecbd062223ef1f4ab668d2400c63c347a7071414";
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

