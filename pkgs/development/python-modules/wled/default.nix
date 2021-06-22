{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, aiohttp
, backoff
, poetry-core
, packaging
, yarl
, aresponses
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "wled";
  version = "0.7.1";
  disabled = pythonOlder "3.8";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-wled";
    rev = "v${version}";
    sha256 = "02xrml9mpq3akwyryg1m7xjmgnlgi5kjvx7vkq6110ai0f9hzpwi";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    backoff
    packaging
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

  pythonImportsCheck = [ "wled" ];

  meta = with lib; {
    description = "Asynchronous Python client for WLED";
    homepage = "https://github.com/frenck/python-wled";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
