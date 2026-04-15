{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  requests,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "zammad-py";
  version = "3.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "joeirimpan";
    repo = "zammad_py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-idPT3H2mlHoC8gHAQHOAcQJKciPZyagVEmojcKbj8ls=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # requires a local zammad instance
    "test_users"
    "test_tickets"
    "test_groups"
    "test_pagination"
    "test_knowledge_bases"
    "test_knowledge_bases_answers"
    "test_knowledge_bases_categories"
  ];

  pythonImportsCheck = [
    "zammad_py"
  ];

  meta = {
    changelog = "https://github.com/joeirimpan/zammad_py/blob/${finalAttrs.src.tag}/HISTORY.md";
    description = "Python API client for accessing zammad REST API";
    homepage = "https://github.com/joeirimpan/zammad_py";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
