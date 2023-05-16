{ lib
, stdenv
, buildPythonPackage
, crytic-compile
, fetchFromGitHub
, makeWrapper
, packaging
, prettytable
, pythonOlder
, setuptools
, solc
<<<<<<< HEAD
, web3
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, withSolc ? false
}:

buildPythonPackage rec {
  pname = "slither-analyzer";
<<<<<<< HEAD
  version = "0.9.6";
=======
  version = "0.9.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "crytic";
    repo = "slither";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-c6H7t+aPPWn1i/30G9DLOmwHhdHHHbcP3FRVVjk1XR4=";
=======
    hash = "sha256-Co3BFdLmSIMqlZVEPJHYH/Cf7oKYSZ+Ktbnd5RZGmfE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  propagatedBuildInputs = [
    crytic-compile
    packaging
    prettytable
    setuptools
<<<<<<< HEAD
    web3
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  postFixup = lib.optionalString withSolc ''
    wrapProgram $out/bin/slither \
      --prefix PATH : "${lib.makeBinPath [ solc ]}"
  '';

  # No Python tests
  doCheck = false;

  meta = with lib; {
    description = "Static Analyzer for Solidity";
    longDescription = ''
      Slither is a Solidity static analysis framework written in Python 3. It
      runs a suite of vulnerability detectors, prints visual information about
      contract details, and provides an API to easily write custom analyses.
    '';
    homepage = "https://github.com/trailofbits/slither";
    changelog = "https://github.com/crytic/slither/releases/tag/${version}";
    license = licenses.agpl3Plus;
<<<<<<< HEAD
    maintainers = with maintainers; [ arturcygan fab hellwolf ];
=======
    maintainers = with maintainers; [ arturcygan fab ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
