{ buildPythonPackage, fetchPypi, lib, python, six, tox, mock, pytest }:

buildPythonPackage rec {
  pname = "smpplib";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0jzxlfwf0861ilh4xyd70hmkdbvdki52aalglm1bnpxkg6i3jhfz";
  };

  propagatedBuildInputs = [ six ];
  checkInputs = [ tox mock pytest ];

  checkPhase = ''
    pytest
  '';

  postInstall = ''
    rm -rf $out/${python.sitePackages}/tests
  '';

  meta = with lib; {
    description = "SMPP library for Python";
    homepage = "https://github.com/python-smpplib/python-smpplib";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.globin ];
  };
}
