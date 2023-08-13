{ lib
, fetchFromGitHub
, python3Packages
, libiconv
, cargo
, coursier
, dotnet-sdk
, git
, glibcLocales
, go
, nodejs
, perl
, testers
, pre-commit
}:

with python3Packages;
buildPythonApplication rec {
  pname = "pre-commit";
  version = "3.3.3";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pre-commit";
    repo = "pre-commit";
    rev = "v${version}";
    hash = "sha256-6FKf4jLHUt2c7LSxFcq53IsfHOWeUSI+P9To0eh48+o=";
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
  ];

  nativeCheckInputs = [
    cargo
    coursier
    dotnet-sdk
    git
    glibcLocales
    go
    libiconv # For rust tests on Darwin
    nodejs
    perl
    pytest-env
    pytest-forked
    pytest-xdist
    pytestCheckHook
    re-assert
  ];

  # i686-linux: dotnet-sdk not available
  doCheck = stdenv.buildPlatform.system != "i686-linux";

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

  preCheck = lib.optionalString (!(stdenv.isLinux && stdenv.isAarch64)) ''
    # Disable outline atomics for rust tests on aarch64-linux.
    export RUSTFLAGS="-Ctarget-feature=-outline-atomics"
  '' + ''
    export GIT_AUTHOR_NAME=test GIT_COMMITTER_NAME=test \
           GIT_AUTHOR_EMAIL=test@example.com GIT_COMMITTER_EMAIL=test@example.com \
           VIRTUALENV_NO_DOWNLOAD=1 PRE_COMMIT_NO_CONCURRENCY=1 LANG=en_US.UTF-8

    # Resolve `.NET location: Not found` errors for dotnet tests
    export DOTNET_ROOT="${dotnet-sdk}"

    export HOME=$(mktemp -d)

    git init -b master

    python -m venv --system-site-packages venv
    source "$PWD/venv/bin/activate"
  '';

  postCheck = ''
    deactivate
  '';

  # Propagating dependencies leaks them through $PYTHONPATH which causes issues
  # when used in nix-shell.
  postFixup = ''
    rm $out/nix-support/propagated-build-inputs
  '';

  disabledTests = [
    # ERROR: The install method you used for conda--probably either `pip install conda`
    # or `easy_install conda`--is not compatible with using conda as an application.
    "test_conda_"
    "test_local_conda_"

    # /build/pytest-of-nixbld/pytest-0/test_install_ruby_with_version0/rbenv-2.7.2/libexec/rbenv-init:
    # /usr/bin/env: bad interpreter: No such file or directory
    "test_ruby_"

    # network
    "test_additional_dependencies_roll_forward"
    "test_additional_golang_dependencies_installed"
    "test_additional_node_dependencies_installed"
    "test_additional_rust_cli_dependencies_installed"
    "test_additional_rust_lib_dependencies_installed"
    "test_coursier_hook"
    "test_coursier_hook_additional_dependencies"
    "test_dart"
    "test_dart_additional_deps"
    "test_dart_additional_deps_versioned"
    "test_docker_hook"
    "test_docker_image_hook_via_args"
    "test_docker_image_hook_via_entrypoint"
    "test_golang_default_version"
    "test_golang_hook"
    "test_golang_hook_still_works_when_gobin_is_set"
    "test_golang_infer_go_version_default"
    "test_golang_system"
    "test_golang_versioned"
    "test_language_version_with_rustup"
    "test_installs_rust_missing_rustup"
    "test_installs_without_links_outside_env"
    "test_local_golang_additional_deps"
    "test_lua"
    "test_lua_additional_dependencies"
    "test_node_additional_deps"
    "test_node_hook_versions"
    "test_perl_additional_dependencies"
    "test_r_hook"
    "test_r_inline"
    "test_r_inline_hook"
    "test_r_local_with_additional_dependencies_hook"
    "test_r_with_additional_dependencies_hook"
    "test_run_a_node_hook_default_version"
    "test_run_lib_additional_dependencies"
    "test_run_versioned_node_hook"
    "test_rust_cli_additional_dependencies"
    "test_swift_language"

    # i don't know why these fail
    "test_install_existing_hooks_no_overwrite"
    "test_installed_from_venv"
    "test_uninstall_restores_legacy_hooks"
    "test_dotnet_"

    # Expects `git commit` to fail when `pre-commit` is not in the `$PATH`,
    # but we use an absolute path so it's not an issue.
    "test_environment_not_sourced"
  ];

  pythonImportsCheck = [
    "pre_commit"
  ];

  passthru.tests.version = testers.testVersion {
    package = pre-commit;
  };

  meta = with lib; {
    description = "A framework for managing and maintaining multi-language pre-commit hooks";
    homepage = "https://pre-commit.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ borisbabic ];
  };
}
