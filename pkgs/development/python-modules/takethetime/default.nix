{ lib
, buildPythonPackage
<<<<<<< HEAD
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "takethetime";
  version = "0.3.1";

  src = fetchPypi {
    pname = "TakeTheTime";
    inherit version;
    sha256 = "sha256-2+MEU6G1lqOPni4/qOGtxa8tv2RsoIN61cIFmhb+L/k=";
=======
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage {
  pname = "takethetime";
  version = "0.3.1";

  # pypi distribution doesn't include tests, so build from source instead
  src = fetchFromGitHub {
    owner = "ErikBjare";
    repo = "TakeTheTime";
    rev = "b0042ac5b1cc9d3b70ef59167b094469ceb660dd";
    sha256 = "sha256-DwsMnP6G3BzOnINttaSC6QKkIKK5qyhUz+lN1DSvkw0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  disabled = pythonOlder "3.6";

<<<<<<< HEAD
  # all tests are timing dependent
  doCheck = false;

  pythonImportsCheck = [ "takethetime" ];

=======
  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "tests/tests.py" ];

  pythonImportsCheck = [ "takethetime" ];

  # Latest release is v0.3.1 on pypi, but this version was not bumped in
  # the setup.py, causing packages that depend on v0.3.1 to fail to build.
  postPatch = ''
    substituteInPlace setup.py \
      --replace "version='0.3'" "version='0.3.1'"
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Simple time taking library using context managers";
    homepage = "https://github.com/ErikBjare/TakeTheTime";
    maintainers = with maintainers; [ huantian ];
    license = licenses.mit;
  };
}
