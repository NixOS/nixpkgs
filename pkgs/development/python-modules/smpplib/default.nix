{ buildPythonPackage, fetchPypi, lib, python, six, tox, mock, pytest }:

buildPythonPackage rec {
  pname = "smpplib";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3d513178a35573f66faac4ef2127c4bd73307ddb463d145b17b013cf709d9ddd";
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
