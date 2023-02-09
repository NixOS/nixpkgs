{ buildPythonPackage, fetchPypi, lib, pypiserver, pytestCheckHook
, setuptools-scm, virtualenv }:

buildPythonPackage rec {
  pname = "setuptools-declarative-requirements";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-V6W5u5rTUMJ46Kpr5M3rvNklubpx1qcSoXimGM+4mPc=";
  };

  buildInputs = [ setuptools-scm ];

  nativeCheckInputs = [ pypiserver pytestCheckHook virtualenv ];

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
