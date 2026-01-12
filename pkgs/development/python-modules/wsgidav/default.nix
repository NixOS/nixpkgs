{
  lib,
  buildPythonPackage,
  cheroot,
  defusedxml,
  fetchFromGitHub,
  jinja2,
  json5,
  lxml,
  pytestCheckHook,
  python-pam,
  pyyaml,
  requests,
  setuptools,
  webtest,
}:

buildPythonPackage rec {
  pname = "wsgidav";
  version = "4.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mar10";
    repo = "wsgidav";
    tag = "v${version}";
    hash = "sha256-vUqNC7ixpta0s7wRC5ROSKMa/MsgEBu5rr0XNu69FRw=";
  };

  __darwinAllowLocalNetworking = true;

  build-system = [ setuptools ];

  dependencies = [
    defusedxml
    jinja2
    json5
    cheroot
    lxml
    pyyaml
  ];

  optional-dependencies = {
    pam = [ python-pam ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    requests
    webtest
  ];

  pythonImportsCheck = [ "wsgidav" ];

  meta = {
    description = "Generic and extendable WebDAV server based on WSGI";
    homepage = "https://wsgidav.readthedocs.io/";
    changelog = "https://github.com/mar10/wsgidav/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "wsgidav";
  };
}
