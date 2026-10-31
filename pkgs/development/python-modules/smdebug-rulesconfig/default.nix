{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "smdebug-rulesconfig";
  version = "1.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "smdebug_rulesconfig";
    hash = "sha256-ehnm6y5rz++8B+SobveojzJJUAGgOL8ox9jnereT/NY=";
  };

  doCheck = false;

  pythonImportsCheck = [ "smdebug_rulesconfig" ];

  meta = {
    description = "These builtin rules are available in Amazon SageMaker";
    homepage = "https://github.com/awslabs/sagemaker-debugger-rulesconfig";
    license = lib.licenses.asl20;
  };
}
