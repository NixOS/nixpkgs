{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  toml,
}:

buildPythonPackage rec {
  pname = "toml-adapt";
  version = "0.3.3";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "firefly-cpp";
    repo = "toml-adapt";
    rev = "refs/tags/${version}";
    hash = "sha256-KD5dTr/wxFbDg3AbfE0jUbgNjvxqDmbHwjY5Dmp6JFI=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    click
    toml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "toml_adapt" ];

  meta = with lib; {
    description = "Simple Command-line interface for manipulating toml files";
    homepage = "https://github.com/firefly-cpp/toml-adapt";
    changelog = "https://github.com/firefly-cpp/toml-adapt/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ firefly-cpp ];
    mainProgram = "toml-adapt";
  };
}
