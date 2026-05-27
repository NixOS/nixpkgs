{
  lib,
  bcrypt,
  buildPythonPackage,
  cheroot,
  defusedxml,
  fetchFromGitHub,
  jinja2,
  json5,
  lxml,
  passlib,
  pytestCheckHook,
  python-pam,
  pyyaml,
  requests,
  setuptools,
  webtest,
}:

buildPythonPackage (finalAttrs: {
  pname = "wsgidav";
  version = "4.3.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mar10";
    repo = "wsgidav";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2Pn5kMioMr4COpcIDEhlfolG0/5hpv8zMO0X7l6fSwY=";
  };

  pythonRelaxDeps = [ "bcrypt" ];

  __darwinAllowLocalNetworking = true;

  build-system = [ setuptools ];

  dependencies = [
    bcrypt
    defusedxml
    jinja2
    json5
    cheroot
    lxml
    passlib
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
    changelog = "https://github.com/mar10/wsgidav/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "wsgidav";
  };
})
