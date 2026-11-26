{
  lib,
  buildPythonPackage,
  python,
  fetchPypi,
  setuptools,
  jinja2,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "tiptapy";
  # upstream only publishes versions on PyPI, the github repository has no tags
  version = "0.21.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-G5lVXVZe8ULsBRJLrmUt8qA2dK+yUS7pi7JyaTyTq/Y=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [ jinja2 ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # test data (tests/data) is not included in the PyPI sdist
  disabledTestPaths = [ "tests/test_transform.py" ];

  # smoke test for the json to html conversion covered by the disabled tests
  postCheck = ''
    ${python.interpreter} -c '
    import tiptapy

    class config:
        DOMAIN = "example.com"

    doc = {
      "type": "doc",
      "content": [{
          "type": "paragraph",
          "content": [
            {"type": "text", "text": "Hello "},
            {"type": "text", "marks": [{"type": "bold"}], "text": "<world>"},
          ]
      }]
    }

    html = tiptapy.BaseDoc(config).render(doc)

    assert html == "<p>Hello <strong>&lt;world&gt;</strong></p>", html
    '
  '';

  pythonImportsCheck = [ "tiptapy" ];

  meta = {
    description = "Library that generates HTML output from JSON export of tiptap editor";
    homepage = "https://github.com/stckme/tiptapy";
    changelog = "https://github.com/stckme/tiptapy/blob/master/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      DutchGerman
      friedow
    ];
  };
})
