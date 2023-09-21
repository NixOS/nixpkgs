{ lib
, buildPythonPackage
, cdcs
, datamodeldict
, fetchFromGitHub
, ipython
, lxml
, numpy
, pandas
, pymongo
, pytestCheckHook
, pythonOlder
, tqdm
}:

buildPythonPackage rec {
  pname = "yabadaba";
  version = "0.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "usnistgov";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-D3dzO+vhf1utBMmX2RUgvxuaPneFnXDseqfz6CMDmv4=";
  };

  propagatedBuildInputs = [
    cdcs
    datamodeldict
    ipython
    lxml
    numpy
    pandas
    pymongo
    tqdm
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "yabadaba"
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  meta = with lib; {
    description = "Abstraction layer allowing for common interactions with databases and records";
    homepage = "https://github.com/usnistgov/yabadaba";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
