{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "webvtt-py";
  version = "0.5.1";
  pyproject = true;
  build-system = [ setuptools ];

  src = fetchFromGitHub {
    owner = "glut23";
    repo = "webvtt-py";
    tag = "${version}";
    hash = "sha256-rsxhZ/O/XAiiQZqdsAfCBg+cdP8Hn56EPbZARkKamdA=";
  };

  meta = {
    homepage = "https://webvtt-py.readthedocs.io/";
    description = "Python library for reading, writing and converting WebVTT caption files.";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ swflint ];
  };
}
