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
  version = "0.1.6";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-tailscale";
    rev = "v${version}";
    sha256 = "1dkmjc78mhgbikfz6mi6g63a36w6v29pdbb3pvgpicg0l649rsc9";
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
