{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hypothesis,
  pytestCheckHook,
  python-dateutil,
  tantivy,
  whoosh,
}:

buildPythonPackage (finalAttrs: {
  pname = "whoosh-compat";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stumpylog";
    repo = "whoosh-compat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DmPrNoOGzgTDwHh1GqyTJ7PkXWu2rbWrvNj+8fnjcpE=";
  };

  build-system = [ hatchling ];

  dependencies = [
    python-dateutil
  ];

  optional-dependencies = {
    tantivy = [ tantivy ];
  };

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
    whoosh
  ]
  ++ finalAttrs.passthru.optional-dependencies.tantivy;

  pythonImportsCheck = [ "whoosh_compat" ];

  meta = {
    description = "Whoosh query-language parser emitting programmatic tantivy queries";
    homepage = "https://github.com/stumpylog/whoosh-compat/";
    changelog = "https://github.com/stumpylog/whoosh-compat/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
