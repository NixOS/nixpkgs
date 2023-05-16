{ lib
<<<<<<< HEAD
, aiohttp
, buildPythonPackage
, click
, fetchFromGitHub
, importlib-metadata
, jinja2
, linkify-it-py
, markdown-it-py
, mdit-py-plugins
, mkdocs-exclude
, msgpack
, poetry-core
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
, rich
, syrupy
, time-machine
, typing-extensions
=======
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, mkdocs-exclude
, markdown-it-py
, mdit-py-plugins
, linkify-it-py
, importlib-metadata
, rich
, typing-extensions
, aiohttp
, click
, jinja2
, msgpack
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
, syrupy
, time-machine
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "textual";
<<<<<<< HEAD
  version = "0.36.0";
=======
  version = "0.23.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-GH5GhXHA/6r3UNeM4YW+khyh1HnyUQBFcSNFaJwFz9c=";
=======
    hash = "sha256-XgJ43yyiwzSH22NzidJ7z+Qh6+pOuAdfL7ZxabJkd3U=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
<<<<<<< HEAD
    aiohttp
    click
    importlib-metadata
    linkify-it-py
    markdown-it-py
    mdit-py-plugins
    mkdocs-exclude
    msgpack
    rich
=======
    rich
    markdown-it-py
    mdit-py-plugins
    linkify-it-py
    importlib-metadata
    aiohttp
    click
    msgpack
    mkdocs-exclude
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ] ++ lib.optionals (pythonOlder "3.11") [
    typing-extensions
  ];

  nativeCheckInputs = [
    jinja2
    pytest-aiohttp
    pytestCheckHook
    syrupy
    time-machine
  ];

  disabledTestPaths = [
    # snapshot tests require syrupy<4
    "tests/snapshot_tests/test_snapshots.py"
  ];

<<<<<<< HEAD
  disabledTests = [
    # Assertion issues
    "test_textual_env_var"
    "test_softbreak_split_links_rendered_correctly"
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [
    "textual"
  ];

<<<<<<< HEAD
  __darwinAllowLocalNetworking = true;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "TUI framework for Python inspired by modern web development";
    homepage = "https://github.com/Textualize/textual";
    changelog = "https://github.com/Textualize/textual/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ joelkoen ];
  };
}
