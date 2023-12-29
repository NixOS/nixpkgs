{ black
, blacken-docs
, fetchFromGitHub
, lib
, python3
, ruff
}:
python3.pkgs.buildPythonApplication rec {
  pname = "nbqa";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "nbQA-dev";
    repo = "nbQA";
    rev = version;
    hash = "sha256-CTF5HisBS44Ta18cVT04UrMIF30WmEBwZBGW7fkKXwk=";
  };

  passthru.optional-dependencies = {
    black = [ black ];
    blacken-docs = [ blacken-docs ];
    flake8 = [ python3.pkgs.flake8 ];
    isort = [ python3.pkgs.isort ];
    jupytext = [ python3.pkgs.jupytext ];
    mypy = [ python3.pkgs.mypy ];
    pylint = [ python3.pkgs.pylint ];
    pyupgrade = [ python3.pkgs.pyupgrade ];
    ruff = [ ruff ];
  };

  propagatedBuildInputs = with python3.pkgs;
    [
      autopep8
      ipython
      tokenize-rt
      tomli
    ]
    ++ builtins.attrValues passthru.optional-dependencies;

  postPatch = ''
    # Force using the Ruff executable rather than the Python package
    substituteInPlace nbqa/__main__.py --replace 'if shell:' 'if shell or main_command == "ruff":'
  '';

  preCheck = ''
    # Allow the tests to run `nbqa` itself from the path
    export PATH="$out/bin":"$PATH"
  '';

  nativeCheckInputs =
    [
      black
      ruff
    ]
    ++ (with python3.pkgs; [
      autoflake
      flake8
      isort
      jupytext
      mdformat
      pre-commit-hooks
      pydocstyle
      pylint
      pytestCheckHook
      pyupgrade
      yapf
    ]);

  disabledTests = [
    # Test data not found
    "test_black_multiple_files"
    "test_black_return_code"
    "test_grep"
    "test_jupytext_on_folder"
    "test_mypy_works"
    "test_running_in_different_dir_works"
    "test_unable_to_reconstruct_message_pythonpath"
    "test_with_subcommand"
    # Broken since ruff was updated to 0.1.2
    # A PR was opened upstream: https://github.com/nbQA-dev/nbQA/issues/834
    "test_ruff_works"
  ];

  disabledTestPaths = [
    # Test data not found
    "tests/test_include_exclude.py"
  ];

  meta = with lib; {
    homepage = "https://github.com/nbQA-dev/nbQA";
    changelog = "https://nbqa.readthedocs.io/en/latest/history.html";
    description = "Run ruff, isort, pyupgrade, mypy, pylint, flake8, black, blacken-docs, and more on Jupyter Notebooks";
    license = licenses.mit;
    maintainers = with maintainers; [ l0b0 ];
    mainProgram = "nbqa";
  };
}
