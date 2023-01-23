{ lib
, python3Packages
, fetchFromGitHub
  # tests
, cargo
, dotnet-sdk
, git
, go
, libiconv
, nodejs
}:

with python3Packages;
buildPythonPackage rec {
  pname = "pre-commit";
  version = "2.20.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "pre-commit";
    repo = "pre-commit";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-+JrnJz+wFbzVw9ysPX85DDE6suF3VU7gQZdp66x5TKY=";
  };

  patches = [
    ./languages-use-the-hardcoded-path-to-python-binaries.patch
    ./hook-tmpl.patch
  ];

  propagatedBuildInputs = [
    cfgv
    identify
    nodeenv
    pyyaml
    toml
    virtualenv
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ] ++ lib.optionals (pythonOlder "3.7") [
    importlib-resources
  ];

  nativeCheckInputs = [
    cargo
    dotnet-sdk
    git
    go
    nodejs
    pytest-env
    pytest-forked
    pytest-xdist
    pytestCheckHook
    re-assert
  ];

  buildInputs = [
    # Required for rust test on x86_64-darwin
    libiconv
  ];

  doCheck = true;

  postPatch = ''
    substituteInPlace pre_commit/resources/hook-tmpl \
      --subst-var-by pre-commit $out
    substituteInPlace pre_commit/languages/python.py \
      --subst-var-by virtualenv ${virtualenv}
    substituteInPlace pre_commit/languages/node.py \
      --subst-var-by nodeenv ${nodeenv}

    patchShebangs pre_commit/resources/hook-tmpl
  '';

  pytestFlagsArray = [
    "--forked"
  ];

  preCheck = ''
    export GIT_AUTHOR_NAME=test GIT_COMMITTER_NAME=test \
           GIT_AUTHOR_EMAIL=test@example.com GIT_COMMITTER_EMAIL=test@example.com \
           VIRTUALENV_NO_DOWNLOAD=1 PRE_COMMIT_NO_CONCURRENCY=1 LANG=en_US.UTF-8

    git init -b master

    export HOME=$(mktemp -d)

    python -m venv --system-site-packages venv
    source "$PWD/venv/bin/activate"
    #$out/bin/pre-commit install
    python setup.py develop
  '';

  postCheck = ''
    deactivate
  '';

  disabledTests = [
    # ERROR: The install method you used for conda--probably either `pip install conda`
    # or `easy_install conda`--is not compatible with using conda as an application.
    "test_conda_"
    "test_local_conda_"

    # /build/pytest-of-nixbld/pytest-0/test_install_ruby_with_version0/rbenv-2.7.2/libexec/rbenv-init:
    # /usr/bin/env: bad interpreter: No such file or directory
    "ruby"

    # network
    "test_additional_dependencies_roll_forward"
    "test_additional_golang_dependencies_installed"
    "test_additional_node_dependencies_installed"
    "test_additional_rust_cli_dependencies_installed"
    "test_additional_rust_lib_dependencies_installed"
    "test_dart_hook"
    "test_dotnet_hook"
    "test_golang_hook"
    "test_golang_hook_still_works_when_gobin_is_set"
    "test_installs_without_links_outside_env"
    "test_local_dart_additional_dependencies"
    "test_local_golang_additional_dependencies"
    "test_local_lua_additional_dependencies"
    "test_local_perl_additional_dependencies"
    "test_local_rust_additional_dependencies"
    "test_lua_hook"
    "test_perl_hook"
    "test_r_hook"
    "test_r_inline_hook"
    "test_r_local_with_additional_dependencies_hook"
    "test_r_with_additional_dependencies_hook"
    "test_run_a_node_hook_default_version"
    "test_run_versioned_node_hook"

    # python2, no explanation needed
    "python2"
    "test_switch_language_versions_doesnt_clobber"

    # docker
    "test_run_a_docker_hook"

    # i don't know why these fail
    "test_install_existing_hooks_no_overwrite"
    "test_installed_from_venv"
    "test_uninstall_restores_legacy_hooks"

    # Expects `git commit` to fail when `pre-commit` is not in the `$PATH`,
    # but we use an absolute path so it's not an issue.
    "test_environment_not_sourced"

    # broken with Git 2.38.1, upstream issue filed at https://github.com/pre-commit/pre-commit/issues/2579
    "test_golang_with_recursive_submodule"
    "test_install_in_submodule_and_run"
    "test_is_in_merge_conflict_submodule"
    "test_get_conflicted_files_in_submodule"
    "test_sub_nothing_unstaged"
    "test_sub_something_unstaged"
    "test_sub_staged"
    "test_submodule_does_not_discard_changes"
    "test_submodule_does_not_discard_changes_recurse"
  ];

  pythonImportsCheck = [
    "pre_commit"
  ];

  meta = with lib; {
    description = "A framework for managing and maintaining multi-language pre-commit hooks";
    homepage = "https://pre-commit.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ borisbabic ];
  };
}
