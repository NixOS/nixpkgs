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
  version = "1.11.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f434fe7e05d940d576ac850709ae57a738ba40e7f317076ea8d359ced5b32320";
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

