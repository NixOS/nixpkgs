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
  version = "2.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "27cc696df66d77703eab5cdfa041b2f9877bbf2b54bcd390de89a4be964ca536";
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

