{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  poetry-core,
  streamlit,
  tqdm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "stqdm";
  version = "0.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Wirg";
    repo = "stqdm";
    tag = "v${version}";
    hash = "sha256-3ws5Naj1QMc4N6AcWvkQ/7+csyX0cxuW6nta+NtE+44=";
  };

  build-system = [
    setuptools
    poetry-core
  ];

  dependencies = [
    tqdm
    streamlit
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "stqdm" ];

  meta = {
    homepage = "https://github.com/Wirg/stqdm";
    changelog = "https://github.com/Wirg/stqdm/releases/tag/${src.tag}";
    description = "Simplest way to handle a progress bar in streamlit app";
    maintainers = with lib.maintainers; [ Luflosi ];
    license = lib.licenses.asl20;
  };
}
