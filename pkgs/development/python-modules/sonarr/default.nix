{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  aiohttp,
  yarl,
  aresponses,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sonarr";
  version = "0.3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ctalkington";
    repo = "python-sonarr";
    rev = version;
    sha256 = "0gi34951qhzzrq59hj93mnkid8cvvknlamkhir6ya9mb23fr7bya";
  };

  propagatedBuildInputs = [
    aiohttp
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "sonarr" ];

  meta = with lib; {
    description = "Asynchronous Python client for the Sonarr API";
    homepage = "https://github.com/ctalkington/python-sonarr";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
