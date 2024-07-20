{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "sre-yield";
  version = "1.2";
  format = "setuptools";

  src = fetchPypi {
    pname = "sre_yield";
    inherit version;
    hash = "sha256-6U8aKjy6//4dzRXB1U5AGhUX4FKqZMfTFk+I3HYde4o=";
  };

  nativeBuildInputs = [ setuptools ];

  doCheck = true;
  nativeCheckInputs = [ unittestCheckHook ];

  meta = with lib; {
    description = "Python library to efficiently generate all values that can match a given regular expression";
    mainProgram = "demo_sre_yield";
    homepage = "https://github.com/sre-yield/sre-yield";
    license = licenses.asl20;
    maintainers = with maintainers; [ danc86 ];
  };
}
