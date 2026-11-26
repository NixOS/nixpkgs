{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitLab,

  # Build system
  hatchling,
  hatch-requirements-txt,
  hatch-vcs,

  # Dependencies
  celery,
  dateparser,
  flask,
  humanize,
  importlib-metadata,
  pika,
  psycopg,
  tabulate,
  swh-storage,

  # Tests
  plotille,
  postgresql,
  postgresqlTestHook,
  pytestCheckHook,
  pytest-mock,
  pytest-postgresql,
  pytest-shared-session-scope,
  pytest-xdist,
  requests-mock,
  simpy,
  swh-journal,
  types-python-dateutil,
  types-pyyaml,
  types-requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "swh-scheduler";
  version = "3.6.0";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.softwareheritage.org";
    group = "swh";
    owner = "devel";
    repo = "swh-scheduler";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QcVC/H0La6BMR72GdJg0kDznTbPZChmTlrzqCQwKdDs=";
  };

  build-system = [
    hatchling
    hatch-requirements-txt
    hatch-vcs
  ];

  dependencies = [
    celery
    dateparser
    flask
    humanize
    importlib-metadata
    pika
    psycopg
    tabulate
    swh-storage
  ];

  pythonImportsCheck = [ "swh.scheduler" ];

  # Many broken tests on Darwin. Disabling them for now.
  doCheck = !stdenv.hostPlatform.isDarwin;

  nativeCheckInputs = [
    plotille
    postgresql
    postgresqlTestHook
    pytestCheckHook
    pytest-mock
    pytest-postgresql
    pytest-shared-session-scope
    pytest-xdist
    requests-mock
    simpy
    swh-journal
    types-python-dateutil
    types-pyyaml
    types-requests
  ];

  disabledTests = [
    "test_setup_log_handler_with_env_configuration"
    "test_task_exception"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isLinux) [
    # > assert elapsed < limit, f"{statement} took {elapsed:.2f} s"
    # AssertionError: locale._simplify_split_align('j ' + 'ﷺ ' * 24000, settings) took 1.28 s
    "test_align_words_added_by_normalization"
    # > assert elapsed < limit, f"{statement} took {elapsed:.2f} s"
    # AssertionError: search_dates('j ' + 'ﷺ ' * 24000, languages=['en']) took 5.02 s
    "test_search_dates_words_added_by_normalization"
    # > assert elapsed < limit, f"{statement} took {elapsed:.2f} s"
    # AssertionError: locale._break_standalone_marks('j' + '´' * 200000) took 2.52 s
    "test_break_standalone_marks"
    # > assert elapsed < limit, f"{statement} took {elapsed:.2f} s"
    # AssertionError: locale._simplify_split_align('j' + '´' * 100000, settings) took 1.71 s
    "test_align_words_added_by_breaking_marks"
    # > assert elapsed < limit, f"{statement} took {elapsed:.2f} s"
    # AssertionError: search_dates('j' + '´' * 48000, languages=['en']) took 3.54 s
    "test_search_dates_words_added_by_breaking_marks"
    # > assert elapsed < limit, f"{statement} took {elapsed:.2f} s"
    # AssertionError: locale.translate(sanitize_date('1' + ' !' * 48000 + 'of!' * (48000 // 3)), settings=settings) took 2.57 s
    "test_translate_run_of_separators_then_skip_words_is_linear"
    # > assert elapsed < limit, f"{statement} took {elapsed:.2f} s"
    # AssertionError: dateparser.parse('1' + ' !' * 24000 + 'of!' * (24000 // 3)) took 2.52 s
    # assert (114.5654826 - 114.19874908) < 0.3
    #  +  where 114.5654826 = process_time()
    "test_long_run_of_spaces_after_a_date"
  ];

  meta = {
    changelog = "https://gitlab.softwareheritage.org/swh/devel/swh-scheduler/-/tags/${finalAttrs.src.tag}";
    description = "Job scheduler for the Software Heritage project";
    homepage = "https://gitlab.softwareheritage.org/swh/devel/swh-scheduler";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ drupol ];
  };
})
