{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit,
  hypothesis,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "validobj";
<<<<<<< HEAD
  version = "1.5";
=======
  version = "1.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-n2CEcZTPr57tbRhw5uFmcWZ1kHdBt2VzG/fS4+LDSyc=";
=======
    hash = "sha256-tab3n3YGTcGk47Ijm/QOocT0zo10LJp4eEF094TJyzg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ flit ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "validobj" ];

<<<<<<< HEAD
  meta = {
    description = "Validobj is library that takes semistructured data (for example JSON and YAML configuration files) and converts it to more structured Python objects";
    homepage = "https://github.com/Zaharid/validobj";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ veprbl ];
=======
  meta = with lib; {
    description = "Validobj is library that takes semistructured data (for example JSON and YAML configuration files) and converts it to more structured Python objects";
    homepage = "https://github.com/Zaharid/validobj";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ veprbl ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
