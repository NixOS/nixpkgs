{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,
  setuptools,
  setuptools-scm,
  distutils,
  ttfautohint,
}:

buildPythonPackage rec {
  pname = "ttfautohint-py";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fonttools";
    repo = "ttfautohint-py";
    rev = "v${version}";
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

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Command line utility and Python library that merges two UFO source format fonts into a single file";
    homepage = "https://github.com/fonttools/ttfautohint-py";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
}
