{ lib
, aioconsole
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, pythonOlder
, setuptools
, websockets
}:

buildPythonPackage rec {
  pname = "whirlpool-sixth-sense";
<<<<<<< HEAD
  version = "0.18.5";
=======
  version = "0.18.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "abmantis";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-0NJsZex054CWfKX2wyJRd6Cnxa89mNrZN59VqIV2MD8=";
=======
    hash = "sha256-GvebWPO+jKDJk7yuMgEctlvKLXeo95GlJUSuI+FMCRU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aioconsole
    aiohttp
    websockets
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  # https://github.com/abmantis/whirlpool-sixth-sense/issues/15
  doCheck = false;

  pythonImportsCheck = [ "whirlpool" ];

  meta = with lib; {
    description = "Python library for Whirlpool 6th Sense appliances";
    homepage = "https://github.com/abmantis/whirlpool-sixth-sense/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
