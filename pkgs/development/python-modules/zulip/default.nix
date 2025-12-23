{
  lib,
  buildPythonPackage,
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
  version = "0.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zulip";
    repo = "python-zulip-api";
    tag = version;
    hash = "sha256-mcqIfha+4nsqlshayLQ2Sd+XOYVKf1FkoczjiFRNybc=";
  };
  sourceRoot = "${src.name}/zulip";

  build-system = [ setuptools ];

  dependencies = [
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

  meta = {
    description = "Bindings for the Zulip message API";
    homepage = "https://github.com/zulip/python-zulip-api";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
