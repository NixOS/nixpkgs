<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchFromGitHub
, ipython
, pytestCheckHook
, pythonOlder
, requests
, setuptools
, tornado
}:

buildPythonPackage rec {
  pname = "snakeviz";
  version = "2.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jiffyclub";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-tW1zUfCgOGQ8TjrKo2lBzGb0MSe25dP0/P9Q6x3736E=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    tornado
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    ipython
    pytestCheckHook
    requests
  ];

  pythonImportsCheck = [
    "snakeviz"
  ];

  preCheck = ''
    export PATH="$PATH:$out/bin";
  '';
=======
{ lib, fetchPypi, buildPythonPackage, tornado }:

buildPythonPackage rec {
  pname = "snakeviz";
  version = "2.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-K4qRmrtefpKv41EnhguMJ2sqeXvv/OLayGFPmM/4byE=";
  };

  # Upstream doesn't run tests from setup.py
  doCheck = false;
  propagatedBuildInputs = [ tornado ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Browser based viewer for profiling data";
    homepage = "https://jiffyclub.github.io/snakeviz";
<<<<<<< HEAD
    changelog = "https://github.com/jiffyclub/snakeviz/blob/v${version}/CHANGES.rst";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.bsd3;
    maintainers = with maintainers; [ nixy ];
  };
}
