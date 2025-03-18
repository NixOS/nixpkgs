{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flask,
  lxml,
  pandas,
  pyyaml,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "succulent";
  version = "0.3.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "firefly-cpp";
    repo = "succulent";
    rev = "refs/tags/${version}";
    hash = "sha256-lU4M/ObX2mhHgYsc72zLp87g1lJ6ikfTeEojEdJwjGs=";
  };

  pythonRelaxDeps = [ "flask" ];

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    flask
    lxml
    pandas
    pyyaml
    xmltodict
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
