{ lib
, buildPythonPackage
, click
, click-completion
, click-default-group
, cucumber-tag-expressions
, fetchFromGitHub
, pluggy
, poetry-core
, pprintpp
, pythonOlder
, pythonRelaxDepsHook
, rich
, tomli
}:

buildPythonPackage rec {
  pname = "ward";
  version = "0.67.0b0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "darrenburns";
    repo = pname;
    rev = "refs/tags/release%2F${version}";
    hash = "sha256-4dEMEEPySezgw3dIcYMl56HrhyaYlql9JvtamOn7Y8g=";
  };

  pythonRelaxDeps = [
    "rich"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    click
    rich
    tomli
    pprintpp
    cucumber-tag-expressions
    click-default-group
    click-completion
    pluggy
  ];

  # Fixture is missing. Looks like an issue with the import of the sample file
  doCheck = false;

  pythonImportsCheck = [
    "ward"
  ];

  meta = with lib; {
    description = "Test framework for Python";
    homepage = "https://github.com/darrenburns/ward";
    changelog = "https://github.com/darrenburns/ward/releases/tag/release%2F${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
