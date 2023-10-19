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
  version = "0.16.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-wled";
    rev = "refs/tags/v${version}";
    hash = "sha256-esINtvctvgl8AqNwCDVnGU+3j/UzEHqY8H1Rws1kQfs=";
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

  nativeCheckInputs = [
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
    changelog = "https://github.com/frenck/python-wled/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
