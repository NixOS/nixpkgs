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
  version = "1.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "codingjoe";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-mORjMEg7Q/2CKZBLICSGF8dcdl98S6mBgJ4jujPGs6M=";
  };

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
