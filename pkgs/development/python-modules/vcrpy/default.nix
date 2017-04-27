{ buildPythonPackage
, lib
, pkgs
, pyyaml
, mock
, contextlib2
, wrapt
, pytest_27
, httpbin
, pytest-httpbin
, yarl
}:

buildPythonPackage rec {
  version = "1.10.5";
  name = "vcrpy-${version}";

  src = pkgs.fetchurl {
    url = "mirror://pypi/v/vcrpy/vcrpy-${version}.tar.gz";
    sha256 = "12kncg6jyvj15mi8ca74514f2x1ih753nhyz769nwvh39r468167";
  };

  buildInputs = [
    pyyaml
    mock
    contextlib2
    wrapt
    pytest_27
    httpbin
    pytest-httpbin
    yarl
  ];

  checkPhase = ''
    py.test --ignore=tests/integration -k "TestVCRConnection.testing_connect"
  '';

  meta = with lib; {
    description = "Automatically mock your HTTP interactions to simplify and speed up testing";
    homepage = https://github.com/kevin1024/vcrpy;
    license = licenses.mit;
  };
}

