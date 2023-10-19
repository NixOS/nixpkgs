{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, requests
, matrix-client
, distro
, click
, typing-extensions
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "zulip";
  version = "0.8.2";

  disabled = pythonOlder "3.6";

  # no sdist on PyPI
  src = fetchFromGitHub {
    owner = "zulip";
    repo = "python-zulip-api";
    rev = version;
    hash = "sha256-Z5WrV/RDQwdKUBF86M5/xWhXn3fGNqJtqO5PTd7s5ME=";
  };
  sourceRoot = "${src.name}/zulip";

  propagatedBuildInputs = [
    requests
    matrix-client
    distro
    click
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "zulip" ];

  meta = with lib; {
    description = "Bindings for the Zulip message API";
    homepage = "https://github.com/zulip/python-zulip-api";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
