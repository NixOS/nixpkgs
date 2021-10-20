{ buildPythonPackage, fetchPypi, lib, pypiserver, pytestCheckHook
, setuptools-scm, virtualenv }:

buildPythonPackage rec {
  pname = "setuptools-declarative-requirements";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1l8zmcnp9h8sp8hsw7b81djaa1a9yig0y7i4phh5pihqz1gdn7yi";
  };

  buildInputs = [ setuptools-scm ];

  checkInputs = [ pypiserver pytestCheckHook virtualenv ];

  # Tests use network
  doCheck = false;

  pythonImportsCheck = [ "declarative_requirements" ];

  meta = with lib; {
    homepage = "https://github.com/s0undt3ch/setuptools-declarative-requirements";
    description = "Declarative setuptools Config Requirements Files Support";
    license = licenses.asl20;
    maintainers = [ maintainers.austinbutler ];
  };
}
