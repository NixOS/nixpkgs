{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  six,
}:

buildPythonPackage rec {
  pname = "ush";
  version = "3.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "tarruda";
    repo = "python-ush";
    rev = version;
    hash = "sha256-eL3vG3yS02enbLYorKvvYKbju9HInffUhrZgkodwhvo=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    six
  ];

  disabledTestPaths = [
    # seems to be outdated?
    "tests/test_glob.py"
  ];

  meta = with lib; {
    description = "Powerful API for invoking with external commands";
    homepage = "https://github.com/tarruda/python-ush";
    license = licenses.mit;
    maintainers = with maintainers; [ ckie ];
  };
}
