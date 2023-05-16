{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "zamg";
<<<<<<< HEAD
  version = "0.3.0";
=======
  version = "0.2.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "killer0071234";
    repo = "python-zamg";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-dt0y423Xw/IFi83DFvGdsN1uzJBMbm13pBYtMgMntuU=";
=======
    hash = "sha256-4q6/+/neWw0BFPjhCPXuLiCwyGqQn96D2pSyK/Yl6U8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov" ""
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "zamg"
  ];

  meta = with lib; {
    description = "Library to read weather data from ZAMG Austria";
    homepage = "https://github.com/killer0071234/python-zamg";
    changelog = "https://github.com/killer0071234/python-zamg/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
