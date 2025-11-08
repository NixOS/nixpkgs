{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  setuptools,
  setuptools-scm,
  boto3,
  click,
  tqdm,
  pyorc,
  plyvel,
  python,
  types-requests,
  swh-core,
  swh-journal,
  swh-model,
  swh-storage,
  pytestCheckHook,
  pytest-kafka,
  pytest-mock,
  tzdata,
  pkgs,
}:

buildPythonPackage rec {
  pname = "swh-export";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.softwareheritage.org";
    group = "swh";
    owner = "devel";
    repo = "swh-export";
    tag = "v${version}";
    hash = "sha256-n97MMYn7EmTrv411YSxUD1+zfbFB8KOSns44N3NqqV8=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    boto3
    click
    tqdm
    pyorc
    plyvel
    types-requests
    swh-core
    swh-journal
    swh-model
    swh-storage
  ];

  preCheck = ''
    # provide timezone data, works only on linux
    export TZDIR=${tzdata}/${python.sitePackages}/tzdata/zoneinfo
  '';

  pythonImportsCheck = [ "swh.export" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-kafka
    pytest-mock
    pkgs.zstd
    pkgs.pv
  ];

  disabledTests = [
    # I don't know how to fix the following error
    # E       fixture 'kafka_server' not found
    "test_parallel_journal_processor"
    "test_parallel_journal_processor_origin"
    "test_parallel_journal_processor_origin_visit_status"
    "test_parallel_journal_processor_offsets"
    "test_parallel_journal_processor_masked"
    "test_parallel_journal_processor_masked_origin"
    "test_parallel_journal_processor_masked_origin_visit_statuses"
  ];

  meta = {
    description = "Software Heritage dataset tools";
    homepage = "https://gitlab.softwareheritage.org/swh/devel/swh-export";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
  };
}
