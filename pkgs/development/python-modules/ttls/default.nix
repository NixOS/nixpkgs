{ lib
, aiohttp
, buildPythonPackage
, colour
, fetchFromGitHub
, poetry-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ttls";
  version = "1.4.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jschlyter";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-zDMgH9o9obfuihX8pXj226T1eMiKx33xyYOGKjdB1wk=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    colour
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "ttls"
  ];

  meta = with lib; {
    description = "Module to interact with Twinkly LEDs";
    homepage = "https://github.com/jschlyter/ttls";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
