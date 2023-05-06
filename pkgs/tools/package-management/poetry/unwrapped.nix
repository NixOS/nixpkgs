{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, installShellFiles
, build
, cachecontrol
, cleo
, crashtest
, dulwich
, filelock
, html5lib
, installer
, jsonschema
, keyring
, lockfile
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
, urllib3
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
}:

buildPythonPackage rec {
  pname = "poetry";
  version = "1.4.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-poetry";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-AiRQFZA5+M1niTzj1RO2lx0QFOMmSzpQo1gzauyTblg=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  propagatedBuildInputs = [
    build
    cachecontrol
    cleo
    crashtest
    dulwich
    filelock
    html5lib
    installer
    jsonschema
    keyring
    lockfile
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
    urllib3
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
    # touches network
    "git"
    "solver"
    "load"
    "vcs"
    "prereleases_if_they_are_compatible"
    "test_executor"
    # requires git history to work correctly
    "default_with_excluded_data"
    # toml ordering has changed
    "lock"
    # fs permission errors
    "test_builder_should_execute_build_scripts"
    # poetry.installation.chef.ChefBuildError: Backend 'poetry.core.masonry.api' is not available.
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

  meta = with lib; {
    changelog = "https://github.com/python-poetry/poetry/blob/${src.rev}/CHANGELOG.md";
    homepage = "https://python-poetry.org/";
    description = "Python dependency management and packaging made easy";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum dotlambda ];
  };
}
