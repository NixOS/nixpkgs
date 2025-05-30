{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  flit-core,
  flit-scm,
  pygments,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "ssdp";
  version = "1.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "codingjoe";
    repo = "ssdp";
    tag = version;
    hash = "sha256-mORjMEg7Q/2CKZBLICSGF8dcdl98S6mBgJ4jujPGs6M=";
  };

  build-system = [
    flit-core
    flit-scm
  ];

  optional-dependencies = {
    cli = [
      click
      pygments
    ];
    pygments = [ pygments ];
  };

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ssdp" ];

  meta = with lib; {
    description = "Python asyncio library for Simple Service Discovery Protocol (SSDP)";
    homepage = "https://github.com/codingjoe/ssdp";
    changelog = "https://github.com/codingjoe/ssdp/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "ssdp";
  };
}
