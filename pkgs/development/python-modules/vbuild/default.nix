{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pscript,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "vbuild";
  version = "0.8.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "manatlan";
    repo = "vbuild";
    rev = "refs/tags/v${version}";
    hash = "sha256-p9v1FiYn0cI+f/25hvjwm7eb1GqxXvNnmXBGwZe9fk0=";
  };

  postPatch = ''
    # Switch to poetry-core, patch can't be applied, https://github.com/manatlan/vbuild/pull/12
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"' \
      --replace-fail 'requires = ["poetry>=0.12"]' 'requires = ["poetry-core>=1.0.0"]' \
      --replace-fail 'build-backend = "poetry.masonry.api"' 'build-backend = "poetry.core.masonry.api"'
  '';

  build-system = [ poetry-core ];

  dependencies = [ pscript ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "vbuild" ];

  disabledTests = [
    # Tests require network access
    "test_min"
    "test_pycomp_onlineClosurable"
  ];

  meta = {
    description = "Module to compile your VueJS components to standalone HTML/JS/CSS";
    homepage = "https://github.com/manatlan/vbuild";
    changelog = "https://github.com/manatlan/vbuild/blob/${src.rev}/changelog.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
