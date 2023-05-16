{ lib
, aenum
, aiodns
, aiohttp
, buildPythonPackage
, faust-cchardet
, fetchFromGitHub
, pyopenssl
, pythonOlder
<<<<<<< HEAD
, pythonRelaxDepsHook
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytz
, related
, requests
, uonet-request-signer-hebe
, yarl
}:

buildPythonPackage rec {
  pname = "vulcan-api";
  version = "2.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "kapi2289";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-5Tj611p4wYn7GjoCtCTRhUZkKyAJglHcci76ciVFWik=";
  };

<<<<<<< HEAD
  pythonRemoveDeps = [
    "faust-cchardet"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    aenum
    aiodns
    aiohttp
    faust-cchardet
    pyopenssl
    pytz
    related
    requests
    uonet-request-signer-hebe
    yarl
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "vulcan"
  ];

  meta = with lib; {
    description = "Python library for UONET+ e-register API";
    homepage = "https://vulcan-api.readthedocs.io/";
<<<<<<< HEAD
    changelog = "https://github.com/kapi2289/vulcan-api/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
