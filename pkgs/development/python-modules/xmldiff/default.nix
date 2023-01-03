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
    description = "Creates diffs of XML files";
    homepage = "https://github.com/Shoobx/xmldiff";
    changelog = "https://github.com/Shoobx/xmldiff/blob/master/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ sfrijters ];
  };
}
