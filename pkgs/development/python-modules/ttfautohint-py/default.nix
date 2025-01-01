{
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
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fonttools";
    repo = "ttfautohint-py";
    rev = "refs/tags/v${version}";
    hash = "sha256-NTog461RpyHKo/Qpicj3tflehaKj9LlZEN9qeCMM6JQ=";
  };

  postPatch = ''
    substituteInPlace src/python/ttfautohint/__init__.py \
      --replace-fail 'find_library("ttfautohint")' '"${lib.getLib ttfautohint}/lib/libttfautohint.so"'
  '';

  env.TTFAUTOHINTPY_BUNDLE_DLL = false;

  build-system = [
    setuptools
    setuptools-scm
    distutils
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
    changelog = "https://github.com/fonttools/ttfautohint-py/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
}
