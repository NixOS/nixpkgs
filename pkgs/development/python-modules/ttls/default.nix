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
  version = "1.6.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jschlyter";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-W7r2XgH8SloL9l/Lw1xWLmjF8aMBHWFe2DQ3tkqu+JQ=";
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
