{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  requests,
  distro,
  click,
  typing-extensions,
  matrix-nio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "zulip";
  version = "0.9.0";

  disabled = pythonOlder "3.8";

  pyproject = true;

  # no sdist on PyPI
  src = fetchFromGitHub {
    owner = "zulip";
    repo = "python-zulip-api";
    rev = version;
    hash = "sha256-YnNXduZ2KOjRHGwhojkqpMP2mwhflk8/f4FVZL8NvHU=";
  };
  sourceRoot = "${src.name}/zulip";

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    requests
    distro
    click
    typing-extensions
  ]
  ++ requests.optional-dependencies.security;

  nativeCheckInputs = [
    matrix-nio
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
