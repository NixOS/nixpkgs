{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "tag-expressions";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c0a49c3c0357976822b03c43db8d4a1c5548e16fb07ac939c10bbd5183f529d";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Package to parse logical tag expressions";
    homepage = "https://github.com/timofurrer/tag-expressions";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ kalbasit ];
  };
}
