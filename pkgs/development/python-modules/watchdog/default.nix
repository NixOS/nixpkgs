{ lib, stdenv
, buildPythonPackage
, fetchPypi
, fetchpatch
, argh
, pathtools
, pyyaml
, pkgs
, pytest-cov
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "watchdog";
  version = "2.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Uy/t2ZPnVVRnH6o2zQTFgM7T+uCEJUp3mvu9iq8AVms=";
  };

  patches = [
    (fetchpatch {
      # Fix test flakiness on Apple Silicon, remove after upgrade to 2.0.6.
      url = "https://github.com/gorakhargosh/watchdog/commit/331fd7c2c819663be39bc146e78ce67553f265fa.patch";
      sha256 = "sha256-pLkZmbPN3qRNHs53OP0HIyDxqYCPPo6yOcBLD3aO2YE=";
    })
  ];

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
