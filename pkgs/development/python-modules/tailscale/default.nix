{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pydantic
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, yarl
}:

buildPythonPackage rec {
  pname = "tailscale";
  version = "0.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-tailscale";
    rev = "v${version}";
    sha256 = "sha256-/tS9ZMUWsj42n3MYPZJYJELzX3h02AIHeRZmD2SuwWE=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    pydantic
    yarl
  ];

  checkInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  postPatch = ''
    # Upstream doesn't set a version for the pyproject.toml
    substituteInPlace pyproject.toml \
      --replace "0.0.0" "${version}" \
      --replace "--cov" ""
  '';

  pythonImportsCheck = [
    "tailscale"
  ];

  meta = with lib; {
    description = "Python client for the Tailscale API";
    homepage = "https://github.com/frenck/python-tailscale";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
