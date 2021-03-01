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
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-N2y8KjXAOSsP5/8W+8GzA/2Z1N2ZEatVge6daa3IiYI=";
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
