{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
  tkinter,
}:

buildPythonPackage rec {
  pname = "tkinter-gl";
  version = "1.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "tkinter_gl";
    sha256 = "sha256-gZgR9ABiMMxOm7mtDZRXV1WyFMS1DrNCel91QcdJgrs=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [ tkinter ];

  pythonImportsCheck = [ "tkinter_gl" ];

  meta = with lib; {
    description = "A base class for GL rendering surfaces in tkinter.";
    homepage = "https://github.com/3-manifolds/tkinter_gl";
    license = licenses.gpl2;
    maintainers = with maintainers; [ noiioiu ];
  };
}
