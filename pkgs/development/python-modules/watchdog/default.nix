{ lib, stdenv
, buildPythonPackage
, fetchPypi
, argh
, pathtools
, pyyaml
, pkgs
, pytest-cov
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "watchdog";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0d1c763652c255e2af00d76cf7d05c7b4867e960092b2696db031f69661c0785";
  };

  buildInputs = lib.optionals stdenv.isDarwin
    [ pkgs.darwin.apple_sdk.frameworks.CoreServices ];

  propagatedBuildInputs = [
    argh
    pathtools
    pyyaml
  ];

  checkInputs = [
    pytest-cov
    pytestCheckHook
  ];

  pythonImportsCheck = [ "watchdog" ];

  meta = with lib; {
    description = "Python API and shell utilities to monitor file system events";
    homepage = "https://github.com/gorakhargosh/watchdog";
    license = licenses.asl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
