{
  attrs,
  buildPythonPackage,
  fetchFromGitea,
  lib,
  pytestCheckHook,
  python,
  setuptools,
}:

buildPythonPackage rec {
  pname = "typedload";
  version = "2.37";
  pyproject = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "ltworf";
    repo = pname;
    rev = version;
    hash = "sha256-H7w2+yVsQPnvVD8Ro/Ibx5gECm/odF7ssV26JrXkN6w=";
  };

  build-system = [ setuptools ];

  preBuild = "python${python.pythonVersion} gensetup.py --pyproject.toml; rm -rf perftest;";

  nativeCheckInputs = [
    attrs
    pytestCheckHook
  ];
  disabledTestPaths =
    [ ]
    ++ lib.optionals (python.pythonOlder "3.10") [ "tests/test_orunion.py" ]
    ++ lib.optionals (python.pythonOlder "3.12") [ "tests/test_typealias.py" ];

  pythonImportsCheck = [ "typedload" ];

  meta = with lib; {
    homepage = "https://ltworf.github.io/typedload/";
    description = "Load and dump json-like data into typed data structures";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ppentchev ];
  };
}
