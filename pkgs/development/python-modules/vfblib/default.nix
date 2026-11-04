{
  lib,
  fetchFromGitHub,
  gitUpdater,
  buildPythonPackage,
  pytestCheckHook,
  uv-build,
  fonttools,
  orjson,
  typing-extensions,
  ufonormalizer,
  ufolib2,
  defcon,
}:

buildPythonPackage rec {
  pname = "vfblib";
  version = "0.12.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LucasFonts";
    repo = "vfbLib";
    tag = "v${version}";
    hash = "sha256-QjGER9jlNc6sbbWGDrJ5Xa2qZLQgV9Pa3ENnOd4snuc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.12.23,<0.13" "uv_build"
  '';

  build-system = [
    uv-build
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
    "fonttools"
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
