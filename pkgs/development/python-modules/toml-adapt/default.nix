{ lib
, buildPythonPackage
, click
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
, toml
}:

buildPythonPackage rec {
  pname = "toml-adapt";
  version = "0.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "firefly-cpp";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-BI0yZlut9PEupa597KN4qdVABOiOLwFpovN8L1lfUmk=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    click
    toml
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "toml_adapt"
  ];

  meta = with lib; {
    description = "A simple Command-line interface for manipulating toml files";
    homepage = "https://github.com/firefly-cpp/toml-adapt";
    license = licenses.mit;
    maintainers = with maintainers; [ firefly-cpp ];
  };
}
