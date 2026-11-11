{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  pathspec,
  pytestCheckHook,
  pyyaml,
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "ssort";
  version = "0.19.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bwhmather";
    repo = "ssort";
    tag = version;
    hash = "sha256-lNM3ASlDKPqoEGfiQDKnK9Y7xjKIv8FggvhMBNlQyxI=";
  };

  # Upstream's release workflow generates src/ssort/_version.py, otherwise the version is 0.0.1+dev
  postPatch = ''
    python scripts/freeze_version.py ${version}
  '';

  build-system = [ setuptools ];

  dependencies = [ pathspec ];

  pythonImportsCheck = [ "ssort" ];

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
    versionCheckHook
  ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  meta = {
    description = "Automatically sorting python statements within a module";
    homepage = "https://github.com/bwhmather/ssort";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tochiaha ];
    mainProgram = "ssort";
  };
}
