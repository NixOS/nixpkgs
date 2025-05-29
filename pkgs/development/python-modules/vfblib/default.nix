{
  lib,
  fetchFromGitHub,
  gitUpdater,
  buildPythonPackage,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
  fonttools,
  orjson,
  typing-extensions,
  ufonormalizer,
  ufolib2,
  defcon,
}:

buildPythonPackage rec {
  pname = "vfblib";
  version = "0.9.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LucasFonts";
    repo = "vfbLib";
    rev = "v${version}";
    hash = "sha256-D5dMjRjgi+4JQbtRc7RNMKG1CXRr2wsHa4pFPhEO6fY=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    fonttools
    orjson
    typing-extensions
    ufonormalizer
    ufolib2
    defcon
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "vfbLib" ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = with lib; {
    description = "Converter and deserializer for FontLab Studio 5 VFB files";
    homepage = "https://github.com/LucasFonts/vfbLib";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ jopejoe1 ];
  };
}
