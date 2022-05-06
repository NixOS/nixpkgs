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
  version = "1.2.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "koesterlab";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-x0CmPiV/6zTnawPW9lgrZ9NsUhmK8fhafwqOP9o3Mdc=";
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
