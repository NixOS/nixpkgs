{ lib
, buildPythonPackage
, click
, defusedxml
, fetchFromGitHub
, httpx
, poetry-core
, pydantic
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, respx
}:

buildPythonPackage rec {
  pname = "sfrbox-api";
  version = "0.0.5";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "hacf-fr";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-6SwZAAWBnxeeunZwUAVQJBU8904czNVheBlRFg5yrOw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'pydantic = ">=1.10.2"' 'pydantic = "*"'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    click
    defusedxml
    httpx
    pydantic
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    respx
  ];

  pythonImportsCheck = [
    "sfrbox_api"
  ];

  meta = with lib; {
    description = "Module for the SFR Box API";
    homepage = "https://github.com/hacf-fr/sfrbox-api";
    changelog = "https://github.com/hacf-fr/sfrbox-api/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
