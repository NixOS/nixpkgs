{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  markdown-it-py,
  platformdirs,
  rich,
  typing-extensions,
  mdit-py-plugins,

  # optional-dependencies
  tree-sitter,
<<<<<<< HEAD
  tree-sitter-c-sharp,
  tree-sitter-html,
  tree-sitter-javascript,
  tree-sitter-make,
  tree-sitter-markdown,
  tree-sitter-python,
  tree-sitter-rust,
  tree-sitter-sql,
  tree-sitter-yaml,
  tree-sitter-zeek,
=======
  tree-sitter-languages,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # tests
  jinja2,
  pytest-aiohttp,
  pytest-xdist,
  pytestCheckHook,
  syrupy,
  time-machine,
<<<<<<< HEAD
=======
  tree-sitter-markdown,
  tree-sitter-python,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "textual";
<<<<<<< HEAD
  version = "6.11.0";
=======
  version = "6.6.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = "textual";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-xfGxI8Q9a11mD+1Ha+wnJn0HMxAzzhUIeeu1sk5cW+w=";
=======
    hash = "sha256-gJWgGyPfSBxZRVuWvcehDs+hr2gmRsL6tleYCVPOPg4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ poetry-core ];

  pythonRelaxDeps = [
    "rich"
  ];
  dependencies = [
    markdown-it-py
    mdit-py-plugins
    platformdirs
    rich
    typing-extensions
  ]
  ++ markdown-it-py.optional-dependencies.plugins
  ++ markdown-it-py.optional-dependencies.linkify;

  optional-dependencies = {
    syntax = [
      tree-sitter
<<<<<<< HEAD
      tree-sitter-c-sharp
      tree-sitter-html
      tree-sitter-javascript
      tree-sitter-make
      tree-sitter-markdown
      tree-sitter-python
      tree-sitter-rust
      tree-sitter-sql
      tree-sitter-yaml
      tree-sitter-zeek
    ];
=======
    ]
    ++ lib.optionals (!tree-sitter-languages.meta.broken) [ tree-sitter-languages ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeCheckInputs = [
    jinja2
    pytest-aiohttp
    pytest-xdist
    pytestCheckHook
    syrupy
    time-machine
    tree-sitter
    tree-sitter-markdown
    tree-sitter-python
  ];

  disabledTestPaths = [
    # Snapshot tests require syrupy<4
    "tests/snapshot_tests/test_snapshots.py"
  ];

  disabledTests = [
    # Assertion issues
    "test_textual_env_var"

    # fixture 'snap_compare' not found
    "test_progress_bar_width_1fr"
  ];

  pytestFlags = [
    # Some tests in groups require state from previous tests
    # See https://github.com/Textualize/textual/issues/4924#issuecomment-2304889067
    "--dist=loadgroup"
  ];

  pythonImportsCheck = [ "textual" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "TUI framework for Python inspired by modern web development";
    homepage = "https://github.com/Textualize/textual";
    changelog = "https://github.com/Textualize/textual/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gepbird ];
  };
}
