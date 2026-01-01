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
    sha256 = "1mpwjfvpmryqqwlbyf500584jclgm3vnxa740yyfzkvb5vmyc6bs";
  };

  doCheck = false;

  pythonImportsCheck = [ "smdebug_rulesconfig" ];

<<<<<<< HEAD
  meta = {
    description = "These builtin rules are available in Amazon SageMaker";
    homepage = "https://github.com/awslabs/sagemaker-debugger-rulesconfig";
    license = lib.licenses.asl20;
=======
  meta = with lib; {
    description = "These builtin rules are available in Amazon SageMaker";
    homepage = "https://github.com/awslabs/sagemaker-debugger-rulesconfig";
    license = licenses.asl20;
    maintainers = with maintainers; [ nequissimus ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
