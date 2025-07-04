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
  version = "0.3.4";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "firefly-cpp";
    repo = "toml-adapt";
    tag = version;
    hash = "sha256-GtwE8P4uP3F6wOrzv/vZ4CJR4tzF7CxpWV/8X/hBZhc=";
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
    changelog = "https://github.com/firefly-cpp/toml-adapt/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ firefly-cpp ];
    mainProgram = "toml-adapt";
  };
}
