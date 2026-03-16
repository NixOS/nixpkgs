{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitLab,
  setuptools,
  setuptools-scm,
  confluent-kafka,
  msgpack,
  swh-core,
  swh-model,
  pytestCheckHook,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "swh-journal";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.softwareheritage.org";
    group = "swh";
    owner = "devel";
    repo = "swh-journal";
    tag = "v${version}";
    hash = "sha256-ycTB7hSjTerJOd+nEv8HbM82vPAO8P1+xooy0oN4eHw=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    confluent-kafka
    msgpack
    swh-core
    swh-model
  ];

  pythonImportsCheck = [ "swh.journal" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  disabledTestPaths = [
    # AssertionError: assert {'author': {'email': b'', 'fullname': b'foo', 'name': b'foo'}, 'date': {'offset_bytes': b'+0200', 'timestamp': {'micro...': 1234567890}}, 'id': b'\x80Y\xdcN\x17\xfc\xd0\xe5\x1c\xa3\xbc\xd6\xb8\x0fEw\xd2\x81\xfd\x08', 'message': b'foo', ...} is None
    "swh/journal/tests/test_kafka_writer.py"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    #Fatal Python error: Segmentation fault"
    "swh/journal/tests/test_client.py"
    "swh/journal/tests/test_pytest_plugin.py"
  ];

  meta = {
    description = "Persistent logger of changes to the archive, with publish-subscribe support";
    homepage = "https://gitlab.softwareheritage.org/swh/devel/swh-journal";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
  };
}
