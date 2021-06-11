{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, argh
, pathtools
, pyyaml
, pytest-timeout
, pytestCheckHook
, CoreServices
}:

buildPythonPackage rec {
  pname = "watchdog";
  version = "2.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-AjfbTZAkhZvqJ9DvtZ/nXu8pCDP9mIuOrXqHmwMIwts=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  propagatedBuildInputs = [
    argh
    pathtools
    pyyaml
  ];

  checkInputs = [
    pytest-timeout
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=watchdog" "" \
      --replace "--cov-report=term-missing" ""
  '';

  pythonImportsCheck = [ "watchdog" ];

  meta = with lib; {
    description = "Python API and shell utilities to monitor file system events";
    homepage = "https://github.com/gorakhargosh/watchdog";
    license = licenses.asl20;
    maintainers = with maintainers; [ goibhniu ];
    # error: use of undeclared identifier 'kFSEventStreamEventFlagItemCloned'
    broken = stdenv.isDarwin;
  };
}
