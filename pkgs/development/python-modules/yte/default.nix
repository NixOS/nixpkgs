{ lib
, buildPythonPackage
, fetchFromGitHub
, plac
, poetry-core
, pytestCheckHook
, pythonOlder
, pyyaml
}:

buildPythonPackage rec {
  pname = "yte";
  version = "1.2.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "koesterlab";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-xu88zupT0/kIzTd56IbKYKBM5+EDI1d+QIEq8zOBWWo=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
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
