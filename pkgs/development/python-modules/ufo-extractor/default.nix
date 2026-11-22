{
  lib,
  buildPythonPackage,
  setuptools,
  setuptools-scm,
  fonttools,
  fontfeatures,
  pytestCheckHook,
  fetchFromGitHub,
}:
buildPythonPackage (finalAttrs: {
  pname = "ufo-extractor";
  version = "0.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "robotools";
    repo = "extractor";
    tag = finalAttrs.version;
    hash = "sha256-SzNNRC2UxjyypgiM0iIicfemC67D6GW2jszNak8yCSM=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    fonttools
    fontfeatures
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "extractor" ];

  meta = {
    description = "Tools for extracting data from font binaries into UFO objects";
    homepage = "https://github.com/robotools/extractor";
    license = lib.licenses.mit;
    changelog = "https://github.com/robotools/extractor/releases/tag/${finalAttrs.src.tag}";
    maintainers = with lib.maintainers; [
      qb114514
    ];
  };
})
