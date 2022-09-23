{ lib
, buildPythonPackage
, dpath
, fetchFromGitHub
, plac
, poetry-core
, pytestCheckHook
, pythonOlder
, pyyaml
}:

buildPythonPackage rec {
  pname = "yte";
  version = "1.5.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "koesterlab";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-7erT5UpejPMIoyqhpYNEON3YWE2l5SdP2olOVpkbNkY=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    dpath
    plac
    pyyaml
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "yte"
  ];

  pytestFlagsArray = [
    "tests.py"
  ];

  preCheck = ''
    # The CLI test need yte on the PATH
    export PATH=$out/bin:$PATH
  '';

  meta = with lib; {
    description = "YAML template engine with Python expressions";
    homepage = "https://github.com/koesterlab/yte";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
