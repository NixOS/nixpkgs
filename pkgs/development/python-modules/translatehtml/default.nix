{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  setuptools,
  argostranslate,
  beautifulsoup4,
}:

let
  inherit (stdenv.hostPlatform) isLinux isAarch64;
  isAarch64Linux = isLinux && isAarch64;
in
buildPythonPackage (finalAttrs: {
  pname = "translatehtml";
  version = "1.5.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "argosopentech";
    repo = "translate-html";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A94N/nfYSVwi0M3SpNFqlXrRNOCpIi9agOCAlH66QcI=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "beautifulsoup4" ];

  dependencies = [
    argostranslate
    beautifulsoup4
  ];

  # aarch64-linux fails cpuinfo test, because /sys/devices/system/cpu/ does not exist in the sandbox:
  # terminate called after throwing an instance of 'onnxruntime::OnnxRuntimeException'
  pythonImportsCheck = lib.optional (!isAarch64Linux) "translatehtml";
  nativeCheckInputs = [ writableTmpDirAsHomeHook ];
  doCheck = !isAarch64Linux;

  meta = {
    description = "Translate HTML using Beautiful Soup and Argos Translate";
    homepage = "https://www.argosopentech.com";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ misuzu ];
  };
})
