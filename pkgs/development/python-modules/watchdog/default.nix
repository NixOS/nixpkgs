{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, argh
, pathtools
, pyyaml
, pytestCheckHook
, CoreServices
}:

buildPythonPackage rec {
  pname = "watchdog";
  version = "2.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-QojTqYQyTbSS5XqhaWZiOKJXjwr1oIFoVSZgj7n2vWE=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  propagatedBuildInputs = [
    argh
    pathtools
    pyyaml
  ];

  checkInputs = [
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
