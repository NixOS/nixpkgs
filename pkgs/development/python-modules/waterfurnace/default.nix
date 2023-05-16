{ lib
, buildPythonPackage
, click
, fetchFromGitHub
, mock
<<<<<<< HEAD
, pytestCheckHook
, requests
, pythonOlder
=======
, pytest-runner
, pytestCheckHook
, requests
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, websocket-client
}:

buildPythonPackage rec {
  pname = "waterfurnace";
  version = "1.1.0";
<<<<<<< HEAD
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "sdague";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    sha256 = "1ba247fw1fvi7zy31zj2wbjq7fajrbxhp139cl9jj67rfvxfv8xf";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'," ""
  '';

  propagatedBuildInputs = [
    click
=======
    rev = "v${version}";
    sha256 = "1ba247fw1fvi7zy31zj2wbjq7fajrbxhp139cl9jj67rfvxfv8xf";
  };

  propagatedBuildInputs = [
    click
    pytest-runner
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    requests
    websocket-client
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

<<<<<<< HEAD
  pythonImportsCheck = [
    "waterfurnace"
  ];
=======
  pythonImportsCheck = [ "waterfurnace" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Python interface to waterfurnace geothermal systems";
    homepage = "https://github.com/sdague/waterfurnace";
<<<<<<< HEAD
    changelog = "https://github.com/sdague/waterfurnace/blob/v${version}/HISTORY.rst";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
