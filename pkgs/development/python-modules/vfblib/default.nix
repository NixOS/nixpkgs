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
  version = "0.10.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LucasFonts";
    repo = "vfbLib";
    tag = "v${version}";
    hash = "sha256-kPPRLs+i181stjoTjgi9XfxsQhx+VKGCggyfhy8o6Nw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools-scm[toml]>=9.2.0" "setuptools-scm"
  '';

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

  pythonRelaxDeps = [
    "ufonormalizer"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "vfbLib" ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Converter and deserializer for FontLab Studio 5 VFB files";
    homepage = "https://github.com/LucasFonts/vfbLib";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
}
