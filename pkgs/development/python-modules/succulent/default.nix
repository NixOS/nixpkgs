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
  version = "0.2.6";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "firefly-cpp";
    repo = "succulent";
    rev = "refs/tags/${version}";
    hash = "sha256-CGDgt6tv+KysrytJsgDKwf2yv6shXizvD67XsGBg+nI=";
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
