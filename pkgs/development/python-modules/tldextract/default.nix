{ lib
, buildPythonPackage
, fetchPypi
, filelock
, idna
, pytest-mock
, pytestCheckHook
, pythonOlder
, requests
, requests-file
, responses
<<<<<<< HEAD
, setuptools
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, setuptools-scm
}:

buildPythonPackage rec {
  pname   = "tldextract";
<<<<<<< HEAD
  version = "3.5.0";
  format = "pyproject";
=======
  version = "3.4.1";
  format = "setuptools";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-TfHGW5W+YdWUKOhhHpVeVObx1Eg9Po1XM9OpBiFV6RA=";
  };

  nativeBuildInputs = [
    setuptools
=======
    hash = "sha256-+p5QxKA77eKh2V3KYg1mFnhIRiaFjM84jPlnGg3Ul6Q=";
  };

  nativeBuildInputs = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    setuptools-scm
  ];

  propagatedBuildInputs = [
    filelock
    idna
    requests
    requests-file
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
    responses
  ];

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace " --pylint" ""
  '';

  pythonImportsCheck = [
    "tldextract"
  ];

  meta = with lib; {
    description = "Python module to accurately separate the TLD from the domain of an URL";
    longDescription = ''
      tldextract accurately separates the gTLD or ccTLD (generic or country code top-level domain)
      from the registered domain and subdomains of a URL.
    '';
    homepage = "https://github.com/john-kurkowski/tldextract";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
