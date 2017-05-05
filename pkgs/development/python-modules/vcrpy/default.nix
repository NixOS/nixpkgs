{ buildPythonPackage
, lib
, six
, fetchPypi
, pyyaml
, mock
, contextlib2
, wrapt
, pytest
, httpbin
, pytest-httpbin
, yarl
, pythonOlder
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "vcrpy";
  version = "1.10.5";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12kncg6jyvj15mi8ca74514f2x1ih753nhyz769nwvh39r468167";
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

