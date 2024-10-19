{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flask,
  lxml,
  numpy,
  pandas,
  pyyaml,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "succulent";
  version = "0.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "firefly-cpp";
    repo = "succulent";
    rev = "refs/tags/${version}";
    hash = "sha256-rD0qKYmWTu0LMRdWgul8OGp1FcczSY2/OxT8+oXO78E=";
  };

  pythonRelaxDeps = [
    "flask"
    "numpy"
  ];

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    flask
    lxml
    numpy
    pandas
    pyyaml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "succulent" ];

  meta = with lib; {
    description = "Collect POST requests";
    homepage = "https://github.com/firefly-cpp/succulent";
    changelog = "https://github.com/firefly-cpp/succulent/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ firefly-cpp ];
  };
}
