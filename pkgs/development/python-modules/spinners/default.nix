{
  buildPythonPackage,
  fetchPypi,
  lib,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "spinners";
  version = "0.0.24";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-HrautHgdcqtC7YoB3PIPMAK/UHQNcVTRL7jJdpv54n8=";
  };

  build-system = [ setuptools ];

  # Tests are not included in the PyPI distribution and the git repo does not have tagged releases
  doCheck = false;
  pythonImportsCheck = [ "spinners" ];

  meta = {
    description = "Spinners for the Terminal";
    homepage = "https://github.com/manrajgrover/py-spinners";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ urbas ];
  };
})
