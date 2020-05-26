{ lib, buildPythonPackage, fetchFromGitHub, python }:

buildPythonPackage rec {
  pname = "untangle";
  version = "1.1.1";
  
  src = fetchFromGitHub {
    owner = "stchris";
    repo = "untangle";
    # 1.1.1 is not tagged on GitHub
    rev = "61b57cd771a40df7d1621e9ec3c68d9acd733d31";
    sha256 = "0ffvlfyyl82xi4akz1lls32lrnlrn44ik41v8x8xh9ghy0n0ick7";
  };
  
  checkPhase = ''
    ${python.interpreter} -m unittest discover -s tests
  '';
  
  meta = with lib; {
    description = "Convert XML documents into Python objects";
    homepage = "http://github.com/stchris/untangle";
    license = licenses.mit;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
