{ lib
, aiohttp
, buildPythonPackage
, colour
, fetchFromGitHub
, poetry-core
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "ttls";
  version = "1.5.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jschlyter";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Oh70mLwTaJ2+uQDr2t6wAgskW5L06mZxtD/8dE01YA0=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    colour
    setuptools
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "ttls"
  ];

  meta = with lib; {
    description = "Module to interact with Twinkly LEDs";
    homepage = "https://github.com/jschlyter/ttls";
    changelog = "https://github.com/jschlyter/ttls/blob/v${version}/CHANGES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
