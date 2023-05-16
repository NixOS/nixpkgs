{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
, python-dotenv
, pytz
, requests
, typing-extensions
, yarl
}:

buildPythonPackage rec {
  pname = "transmission-rpc";
<<<<<<< HEAD
  version = "6.0.0";
=======
  version = "4.2.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Trim21";
    repo = "transmission-rpc";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-gRyxQ6Upc1YBRhciVfyt0IGjv8K8ni4I1ODRS6o3tHA=";
=======
    hash = "sha256-+NjJscLRGNSDmyrOMjwUMtJPVz2N32Cy80Q3iu33QJc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    requests
    typing-extensions
  ];

  nativeCheckInputs = [
    python-dotenv
    pytz
    pytestCheckHook
    yarl
  ];

  pythonImportsCheck = [
    "transmission_rpc"
  ];

  disabledTests = [
    # Tests require a running Transmission instance
    "test_real"
  ];

  meta = with lib; {
    description = "Python module that implements the Transmission bittorent client RPC protocol";
    homepage = "https://github.com/Trim21/transmission-rpc";
    changelog = "https://github.com/trim21/transmission-rpc/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ eyjhb ];
  };
}
