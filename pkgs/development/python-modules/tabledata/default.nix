{ buildPythonPackage
, fetchFromGitHub
, lib
, dataproperty
, typepy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "tabledata";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-6Nkdc32cp9wbmw7cnBn5VAJKfqxNunyxExuZ9b+qWNY=";
  };

  propagatedBuildInputs = [ dataproperty typepy ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/thombashi/tabledata";
    description = "A library to represent tabular data";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.mit;
  };
}
