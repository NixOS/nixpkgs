{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pyusb,
}:

buildPythonPackage rec {
  pname = "usbtmc";
  version = "0.8";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "python-ivi";
    repo = "python-usbtmc";
    rev = "v${version}";
    hash = "sha256-69kqBTqnVqdWC2mqlXylzb9VkdhwTGZI0Ykf6lqbypI=";
  };

  propagatedBuildInputs = [ pyusb ];

<<<<<<< HEAD
  meta = {
    description = "Python implementation of the USBTMC instrument control protocol";
    homepage = "http://alexforencich.com/wiki/en/python-usbtmc/start";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bjornfor ];
=======
  meta = with lib; {
    description = "Python implementation of the USBTMC instrument control protocol";
    homepage = "http://alexforencich.com/wiki/en/python-usbtmc/start";
    license = licenses.mit;
    maintainers = with maintainers; [ bjornfor ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
