{ buildPythonPackage
, fetchPypi
, docutils
, ditaa
, lib
, sphinx
, substituteAll
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-ditaa";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0kpqqf7cn66i3zpmwb3rda847shlfdspcxngnjzhk2jwpn5k2ykm";
  };

  doCheck = false;

  propagatedBuildInputs = [ ditaa docutils sphinx ];

  # no tests in package

  meta = with lib; {
    description = "ditaa extension for Sphinx";
    homepage = "https://pypi.org/project/sphinxcontrib-ditaa";
    maintainers = with maintainers; [ felixsinger ];
    license = licenses.bsd0;
  };
}
