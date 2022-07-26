{ lib
, aiohttp
, awesomeversion
, backoff
, buildPythonPackage
, cachetools
, fetchFromGitHub
, poetry-core
, yarl
, aresponses
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "wled";
  version = "0.13.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-wled";
    rev = "v${version}";
    sha256 = "sha256-Rv0jaKkN6jQ7oiv1cBYx4HAr7IqPm57jZFykXayp0T0=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    awesomeversion
    backoff
    cachetools
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
    "wled"
  ];

  meta = with lib; {
    description = "Asynchronous Python client for WLED";
    homepage = "https://github.com/frenck/python-wled";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
