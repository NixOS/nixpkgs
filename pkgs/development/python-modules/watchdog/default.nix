{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, argh
, pathtools
, pyyaml
, flaky
, pytest-timeout
, pytestCheckHook
, CoreServices
}:

buildPythonPackage rec {
  pname = "watchdog";
  version = "2.1.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-o25132x2fL9G9hqRxws7pxgR36CspKMk2UB6Bqi3ouc=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  propagatedBuildInputs = [
    argh
    pathtools
    pyyaml
  ];

  checkInputs = [
    flaky
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
