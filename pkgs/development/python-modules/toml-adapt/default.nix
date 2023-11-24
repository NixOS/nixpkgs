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
  version = "0.2.12";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "firefly-cpp";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-DtxA63lutgjGMH8GYz5r6IFEuuZ9iFGPGup960c4xgE=";
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
