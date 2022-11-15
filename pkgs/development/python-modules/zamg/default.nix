{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "zamg";
  version = "0.1.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "killer0071234";
    repo = "python-zamg";
    rev = "refs/tags/v${version}";
    hash = "sha256-R3byV8llg7X+KYuYTsEtdLSFfLsPD4tyqAaU0CifDks=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov" ""
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "zamg"
  ];

  meta = with lib; {
    description = "Library to read weather data from ZAMG Austria";
    homepage = "https://github.com/killer0071234/python-zamg";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
