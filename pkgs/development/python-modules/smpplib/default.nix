{ buildPythonPackage, fetchPypi, lib, python, six, tox, mock, pytest }:

buildPythonPackage rec {
  pname = "smpplib";
  version = "2.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c0b01947b47e404f42ccb59e906b6e4eb507963c971d59b44350db0f29c76166";
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
