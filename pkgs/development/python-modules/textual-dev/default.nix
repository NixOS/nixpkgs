{ lib
, aiohttp
, buildPythonPackage
, click
, fetchFromGitHub
, msgpack
, poetry-core
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
, textual
, time-machine
, typing-extensions
}:

buildPythonPackage rec {
  pname = "textual-dev";
  version = "1.2.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = "textual-dev";
    # we use rev instead of tag since upstream doesn't use tags
    rev = "6afa9013a42cb18e9105e49d6a56874097f7c812";
    hash = "sha256-ef35389ZMU/zih7Se3KkMGECf5o2i5y6up64/1AECas=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    click
    msgpack
    textual
    typing-extensions
  ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
    time-machine
  ];

  pythonImportsCheck = [
    "textual_dev"
  ];

  meta = with lib; {
    description = "Development tools for Textual";
    homepage = "https://github.com/Textualize/textual-dev";
    license = licenses.mit;
    maintainers = with maintainers; [ yannip ];
  };
}
