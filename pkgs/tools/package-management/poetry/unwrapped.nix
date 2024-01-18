{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, installShellFiles
, pythonRelaxDepsHook
, build
, cachecontrol
, cleo
, crashtest
, dulwich
, fastjsonschema
, installer
, keyring
, packaging
, pexpect
, pkginfo
, platformdirs
, poetry-core
, poetry-plugin-export
, pyproject-hooks
, requests
, requests-toolbelt
, shellingham
, tomlkit
, trove-classifiers
, virtualenv
, xattr
, tomli
, importlib-metadata
, cachy
, deepdiff
, flatdict
, pytestCheckHook
, httpretty
, pytest-mock
, pytest-xdist
, pythonAtLeast
, darwin
}:

buildPythonPackage rec {
  pname = "poetry";
  version = "1.7.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "python-poetry";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-PM3FIZYso7p0Oe0RpiPuxHrQrgnMlkT5SVeaJPK/J94=";
  };

  nativeBuildInputs = [
    installShellFiles
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    # platformdirs 4.x is backwards compatible; https://github.com/python-poetry/poetry/commit/eb80d10846f7336b0b2a66ce2964e72dffee9a1c
    "platformdirs"
    # xattr 1.0 is backwards compatible modulo dropping Python 2 support: https://github.com/xattr/xattr/compare/v0.10.0...v1.0.0
    "xattr"
  ];

  propagatedBuildInputs = [
    build
    cachecontrol
    cleo
    crashtest
    dulwich
    fastjsonschema
    installer
    keyring
    packaging
    pexpect
    pkginfo
    platformdirs
    poetry-core
    poetry-plugin-export
    pyproject-hooks
    requests
    requests-toolbelt
    shellingham
    tomlkit
    trove-classifiers
    virtualenv
  ] ++ lib.optionals (stdenv.isDarwin) [
    xattr
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ] ++ lib.optionals (pythonOlder "3.10") [
    importlib-metadata
  ] ++ cachecontrol.optional-dependencies.filecache;

  postInstall = ''
    installShellCompletion --cmd poetry \
      --bash <($out/bin/poetry completions bash) \
      --fish <($out/bin/poetry completions fish) \
      --zsh <($out/bin/poetry completions zsh) \
  '';

  nativeCheckInputs = [
    cachy
    deepdiff
    flatdict
    pytestCheckHook
    httpretty
    pytest-mock
    pytest-xdist
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.ps
  ];

  preCheck = (''
    export HOME=$TMPDIR
  '' + lib.optionalString (stdenv.isDarwin && stdenv.isAarch64) ''
    # https://github.com/python/cpython/issues/74570#issuecomment-1093748531
    export no_proxy='*';
  '');

  postCheck = lib.optionalString (stdenv.isDarwin && stdenv.isAarch64) ''
    unset no_proxy
  '';

  disabledTests = [
    "test_env_system_packages_are_relative_to_lib"
    "test_install_warning_corrupt_root"
    "test_installer_with_pypi_repository"
    # touches network
    "git"
    "solver"
    "load"
    "vcs"
    "prereleases_if_they_are_compatible"
    "test_builder_setup_generation_runs_with_pip_editable"
    "test_executor"
    # requires git history to work correctly
    "default_with_excluded_data"
    # toml ordering has changed
    "lock"
    # fs permission errors
    "test_builder_should_execute_build_scripts"
    # poetry.installation.chef.ChefBuildError: Backend 'poetry.core.masonry.api' is not available.
    "test_isolated_env_install_success"
    "test_prepare_sdist"
    "test_prepare_directory"
    "test_prepare_directory_with_extensions"
    "test_prepare_directory_editable"
  ] ++ lib.optionals (pythonAtLeast "3.10") [
    # RuntimeError: 'auto_spec' might be a typo; use unsafe=True if this is intended
    "test_info_setup_complex_pep517_error"
  ];

  # Allow for package to use pep420's native namespaces
  pythonNamespaces = [
    "poetry"
  ];

  # Unset ambient PYTHONPATH in the wrapper, so Poetry only ever runs with its own,
  # isolated set of dependencies. This works because the correct PYTHONPATH is set
  # in the Python script, which runs after the wrapper.
  makeWrapperArgs = ["--unset PYTHONPATH"];

  meta = with lib; {
    changelog = "https://github.com/python-poetry/poetry/blob/${src.rev}/CHANGELOG.md";
    homepage = "https://python-poetry.org/";
    description = "Python dependency management and packaging made easy";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum dotlambda ];
    mainProgram = "poetry";
  };
}
