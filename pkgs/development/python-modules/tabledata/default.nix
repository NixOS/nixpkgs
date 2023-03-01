{ buildPythonPackage
, fetchFromGitHub
, lib
, dataproperty
, typepy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "tabledata";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-oDo+wj5MO5Zopya2lp+sU/LAnFGZy6OIdW4YgcAmw1Q=";
  };

  propagatedBuildInputs = [ dataproperty typepy ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/thombashi/tabledata";
    description = "A library to represent tabular data";
    changelog = "https://github.com/thombashi/tabledata/releases/tag/v${version}";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.mit;
  };
}
