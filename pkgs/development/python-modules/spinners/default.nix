{
  buildPythonPackage,
  fetchPypi,
  isPy27,
  lib,
}:

buildPythonPackage rec {
  pname = "spinners";
  version = "0.0.24";
  format = "setuptools";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HrautHgdcqtC7YoB3PIPMAK/UHQNcVTRL7jJdpv54n8=";
  };

  # Tests are not included in the PyPI distribution and the git repo does not have tagged releases
  doCheck = false;
  pythonImportsCheck = [ "spinners" ];

  meta = with lib; {
    description = "Spinners for the Terminal";
    homepage = "https://github.com/manrajgrover/py-spinners";
    license = licenses.mit;
    maintainers = with maintainers; [ urbas ];
  };
}
