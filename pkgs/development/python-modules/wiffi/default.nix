{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "wiffi";
  version = "1.1.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mampfes";
    repo = "python-wiffi";
    tag = version;
    hash = "sha256-pnbzJxq8K947Yg54LysPPho6IRKf0cc+szTETgyzFao=";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "wiffi" ];

  meta = {
    description = "Python module to interface with STALL WIFFI devices";
    homepage = "https://github.com/mampfes/python-wiffi";
    changelog = "https://github.com/mampfes/python-wiffi/blob/${version}/HISTORY.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
