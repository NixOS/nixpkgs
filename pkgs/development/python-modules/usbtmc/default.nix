{ lib, fetchFromGitHub, buildPythonPackage, pyusb }:

buildPythonPackage rec {
  pname = "usbtmc";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "python-ivi";
    repo = "python-usbtmc";
    rev = "v${version}";
    sha256 = "sha256-69kqBTqnVqdWC2mqlXylzb9VkdhwTGZI0Ykf6lqbypI=";
  };

  propagatedBuildInputs = [ pyusb ];

  meta = with lib; {
    description = "Python implementation of the USBTMC instrument control protocol";
    homepage = "http://alexforencich.com/wiki/en/python-usbtmc/start";
    license = licenses.mit;
    maintainers = with maintainers; [ bjornfor ];
  };
}
