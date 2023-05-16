{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, aiohttp
, asn1
, python-dateutil
, tenacity
}:

buildPythonPackage rec {
  pname = "smart-meter-texas";
<<<<<<< HEAD
  version = "0.5.3";
=======
  version = "0.5.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "grahamwetzler";
    repo = "smart-meter-texas";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-8htd5fLrtkaVlSEm+RB7tWA5YZkcAOjAXVNzZiMwP7k=";
=======
    rev = "v${version}";
    hash = "sha256-rjMRV5MekwRkipes2nWos/1zi3sD+Ls8LyD3+t5FOZc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner" ""
  '';

  propagatedBuildInputs = [
    aiohttp
    asn1
    python-dateutil
    tenacity
  ];

  # no tests implemented
  doCheck = false;

  meta = with lib; {
    description = "Connect to and retrieve data from the unofficial Smart Meter Texas API";
    homepage = "https://github.com/grahamwetzler/smart-meter-texas";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
