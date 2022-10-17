{ lib
, buildPythonPackage
, fetchPypi
, lxml
, setuptools
, six
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "xmldiff";
  version = "2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Bb6iDOHyyWeGg7zODDupmB+H2StwnRkOAYvL8Efsz2M=";
  };

  propagatedBuildInputs = [ lxml setuptools six ];

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/Shoobx/xmldiff";
    description = "Creates diffs of XML files";
    license = licenses.mit;
    maintainers = with maintainers; [ sfrijters ];
  };
}
