{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, aiohttp
, yarl
, aresponses
, poetry-core
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "twentemilieu";
  version = "0.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-twentemilieu";
    rev = "v${version}";
    sha256 = "sha256-7HQ0+h8oiyY+TacQdX84K0r994rH0AMZAvZz8PUvQl0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--cov" "" \
      --replace '"0.0.0"' '"${version}"'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    yarl
  ];

  checkInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "twentemilieu" ];

  meta = with lib; {
    description = "Python client for Twente Milieu";
    homepage = "https://github.com/frenck/python-twentemilieu";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
