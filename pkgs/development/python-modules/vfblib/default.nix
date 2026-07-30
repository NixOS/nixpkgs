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
  version = "0.11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LucasFonts";
    repo = "vfbLib";
    tag = "v${version}";
    hash = "sha256-AXZKJgZADE0J4WHB6pn/b6K3Jwawyq6j0tRt6HyRkpk=";
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
