{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  tkinter,
}:

buildPythonPackage {
  pname = "tkinter-gl";
  version = "1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "3-manifolds";
    repo = "tkinter_gl";
    # release of version 1.0
    rev = "6a8cd3af321738ed11bc067965a8e519bfc9dd41";
    hash = "sha256-ObI8EEQ7mAOAuV6f+Ld4HH0xkFzqiAZqHDvzjwPA/wM=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [ tkinter ];

  pythonImportsCheck = [ "tkinter_gl" ];

  meta = with lib; {
    description = "A base class for GL rendering surfaces in tkinter.";
    homepage = "https://github.com/3-manifolds/tkinter_gl";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ noiioiu ];
  };
}
