{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lib,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "wsdot";
  version = "0.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ucodery";
    repo = "wsdot";
    tag = "v${version}";
    hash = "sha256-ZmQXa/C5AxqzAdmxqStWnCLrm3AJb/krxbDhtLYMWPw=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    pydantic
  ];

  pythonImportsCheck = [ "wsdot" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/ucodery/wsdot/releases/tag/${src.tag}";
    description = "Python wrapper of the wsdot.wa.gov APIs";
    homepage = "https://github.com/ucodery/wsdot";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
