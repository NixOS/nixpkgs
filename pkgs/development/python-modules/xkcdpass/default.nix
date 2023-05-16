{ lib
, buildPythonPackage
, fetchPypi
, installShellFiles
, pytestCheckHook
, pythonAtLeast
, pythonOlder
}:

buildPythonPackage rec {
  pname = "xkcdpass";
<<<<<<< HEAD
  version = "1.19.4";
=======
  version = "1.19.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-KTXVS0gtGby1Rla9oBy77J7kH/1C0jWlJwX9lcq3D9c=";
=======
    hash = "sha256-xaLpSHRtpv5QToQEKE9FfY6Y2m31BHxrs/cbGIgunSo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "xkcdpass"
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.10") [
    # https://github.com/redacted/XKCD-password-generator/issues/138
    "test_entropy_printout_valid_input"
  ];

  postInstall = ''
    installManPage *.?
    install -Dm444 -t $out/share/doc/${pname} README*
  '';

  meta = with lib; {
    description = "Generate secure multiword passwords/passphrases, inspired by XKCD";
    homepage = "https://github.com/redacted/XKCD-password-generator";
    license = licenses.bsd3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
