{ lib , python, buildPythonPackage , fetchPypi, typing-extensions }:

buildPythonPackage rec {
  pname = "stringly";
  version = "1.0b2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09fi9dgf27v4qi0mwwms7hpwim9qpyalckd66p7nlmfp6c8bzppq";
  };

  pythonImportsCheck = [ "stringly" ];

  propagatedBuildInputs = [
    typing-extensions
  ];

  checkPhase = ''
    ${python.interpreter} -m unittest
  '';

  meta = with lib; {
    description = "Stringly: Human Readable Object Serialization";
    homepage = "https://github.com/evalf/stringly";
    license = licenses.mit;
    maintainers = [ maintainers.Scriptkiddi ];
  };
}
