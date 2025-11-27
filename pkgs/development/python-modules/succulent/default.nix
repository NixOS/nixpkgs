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
}:

buildPythonPackage rec {
  pname = "succulent";
  version = "0.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "firefly-cpp";
    repo = "succulent";
    tag = version;
    hash = "sha256-e2F2g8NfMyAfiHPUq8KRs99pu7yEZTpWraxhsAZXE4Q=";
  };

  pythonRelaxDeps = [
    "flask"
    "lxml"
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
    changelog = "https://github.com/firefly-cpp/succulent/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ firefly-cpp ];
  };
}
