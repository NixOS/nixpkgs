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
<<<<<<< HEAD
  version = "0.2.1";
=======
  version = "0.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "usnistgov";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-D3dzO+vhf1utBMmX2RUgvxuaPneFnXDseqfz6CMDmv4=";
=======
    hash = "sha256-PXmkRbCFag2WAtodwgb3kX+hRDZdCKKi/YwAMSQePxQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
