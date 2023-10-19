{ lib
, buildPythonPackage
, fetchFromGitHub
, flask
, pandas
, pyyaml
, poetry-core
, pytestCheckHook
, pythonRelaxDepsHook
, pythonOlder
, toml-adapt
}:

buildPythonPackage rec {
  pname = "succulent";
  version = "0.2.5";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "firefly-cpp";
    repo = "succulent";
    rev = version;
    hash = "sha256-fSsb2UQM69AAjJd/Rvzuok7jBeAa6udbB8FbuNP8Ztw=";
  };

  pythonRelaxDeps = [
    "flask"
    "pandas"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    flask
    pandas
    pyyaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "succulent"
  ];

  meta = with lib; {
    description = "Collect POST requests";
    homepage = "https://github.com/firefly-cpp/succulent";
    changelog = "https://github.com/firefly-cpp/succulent/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ firefly-cpp ];
  };
}
