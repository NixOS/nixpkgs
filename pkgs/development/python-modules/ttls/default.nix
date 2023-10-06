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
  version = "1.8.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jschlyter";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-7w+VFxqv1htN5rKvMbcBV6uYqT3PT0ocv3S9Om2Ol3k=";
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
