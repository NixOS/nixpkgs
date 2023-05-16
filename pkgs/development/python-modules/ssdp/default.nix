{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, flit-scm
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ssdp";
<<<<<<< HEAD
  version = "1.3.0";
=======
  version = "1.1.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "codingjoe";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-mORjMEg7Q/2CKZBLICSGF8dcdl98S6mBgJ4jujPGs6M=";
=======
    hash = "sha256-D2mww3sEc2SvufWNmT450a2CW+ogROn3RHypljkebuY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--cov" ""
  '';

  nativeBuildInputs = [
    flit-core
    flit-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "ssdp"
  ];

  meta = with lib; {
    description = "Python asyncio library for Simple Service Discovery Protocol (SSDP)";
    homepage = "https://github.com/codingjoe/ssdp";
    changelog = "https://github.com/codingjoe/ssdp/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
