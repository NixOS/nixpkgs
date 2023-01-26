{ buildPythonPackage
, dataproperty
, typepy

, fetchFromGitHub
, lib
}:

buildPythonPackage rec {
  pname = "tabledata";
  version = "1.3.0";

  propagatedBuildInputs = [ dataproperty typepy ];

  # test inputs introduce a circular dependency
  doCheck = false;

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-6Nkdc32cp9wbmw7cnBn5VAJKfqxNunyxExuZ9b+qWNY=";
  };

  meta = with lib; {
    homepage = "https://github.com/thombashi/tabledata";
    description = "tabledata is a python library to represent tabular data";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.mit;
  };
}
