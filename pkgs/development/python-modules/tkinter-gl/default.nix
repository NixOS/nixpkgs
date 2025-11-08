{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  tkinter,
}:

buildPythonPackage rec {
  pname = "tkinter-gl";
  version = "1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "3-manifolds";
    repo = "tkinter_gl";
    tag = "v${version}_as_released";
    hash = "sha256-ObI8EEQ7mAOAuV6f+Ld4HH0xkFzqiAZqHDvzjwPA/wM";
  };

  build-system = [ setuptools-scm ];

  dependencies = [ tkinter ];

  pythonImportsCheck = [ "tkinter_gl" ];

  meta = {
    description = "Base class for GL rendering surfaces in tkinter";
    changelog = "https://github.com/3-manifolds/tkinter_gl/releases/tag/${src.tag}";
    homepage = "https://github.com/3-manifolds/tkinter_gl";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      noiioiu
      alejo7797
    ];
  };
}
