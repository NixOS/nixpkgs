{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
  distutils,
  ttfautohint,
  fonttools,
}:

buildPythonPackage rec {
  pname = "ttfautohint-py";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fonttools";
    repo = "ttfautohint-py";
    tag = "v${version}";
    hash = "sha256-wA8su7HEQnDbCShrX9fiP/VKNMtMqeayHbQXHqy8iOA=";
  };

  postPatch = ''
    substituteInPlace src/python/ttfautohint/__init__.py \
      --replace-fail '_exe_full_path = None' '_exe_full_path = "${lib.getExe ttfautohint}"'
  '';

  env.TTFAUTOHINTPY_BUNDLE_DLL = false;

  build-system = [
    setuptools
    setuptools-scm
    distutils
  ];

  dependencies = [
    setuptools # for pkg_resources
  ];

  buildInputs = [ ttfautohint ];

  nativeCheckInputs = [
    pytestCheckHook
    fonttools
  ];

  pythonImportsCheck = [ "ttfautohint" ];

  meta = {
    description = "Python wrapper for ttfautohint, a free auto-hinter for TrueType fonts";
    homepage = "https://github.com/fonttools/ttfautohint-py";
    changelog = "https://github.com/fonttools/ttfautohint-py/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
}
