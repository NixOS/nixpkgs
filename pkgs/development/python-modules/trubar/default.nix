{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  nix-update-script,
  pytestCheckHook,
  libcst,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "trubar";
  version = "0.3.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "janezd";
    repo = "trubar";
    tag = version;
    hash = "sha256-ChKmeACEMnFcMYSdkdVlFiE3td171ihUS2A+qsP5ASk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    libcst
    pyyaml
  ];

  pythonImportsCheck = [ "trubar" ];

  nativeCheckInputs = [ pytestCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Utility for translation of strings and f-strings in Python files";
    homepage = "https://github.com/janezd/trubar";
    changelog = "https://github.com/janezd/trubar/releases/tag/${version}";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.lucasew ];
  };
}
