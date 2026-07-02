{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  colorama,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "simber";
  version = "0.2.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deepjyoti30";
    repo = "simber";
    tag = version;
    hash = "sha256-kHoFZD7nhVxJu9MqePLkL7KTG2saPecY9238c/oeEco=";
  };

  build-system = [ setuptools ];

  dependencies = [ colorama ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "simber" ];

  meta = {
    description = "Simple, minimal and powerful logger for Python";
    homepage = "https://github.com/deepjyoti30/simber";
    changelog = "https://github.com/deepjyoti30/simber/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ j0hax ];
  };
}
