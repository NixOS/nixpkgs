{ lib
, beautifulsoup4
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, rapidfuzz
, requests
}:

buildPythonPackage rec {
  pname = "syncedlyrics";
  version = "0.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rtcq";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-dH9irIah9CdZ9Kv7bIymP1o5ifWEYCiSqegUpu8Y+Tg=";
  };

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "rapidfuzz"
  ];

  propagatedBuildInputs = [
    requests
    rapidfuzz
    beautifulsoup4
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "syncedlyrics"
  ];

  pytestFlagsArray = [
    "test.py::test_all_providers"
  ];

  meta = with lib; {
    description = "Module to get LRC format (synchronized) lyrics";
    homepage = "https://github.com/rtcq/syncedlyrics";
    changelog = "https://github.com/rtcq/syncedlyrics/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
