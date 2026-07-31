{
  buildPythonPackage,
  fetchPypi,
  lib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "spinners";
  version = "0.0.24";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zz2z6dpdjdq5z8m8w8dfi8by0ih1zrdq0caxm1anwhxg2saxdhy";
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
}
