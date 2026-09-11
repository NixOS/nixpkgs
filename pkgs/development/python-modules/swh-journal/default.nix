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
  confluent-kafka,
  msgpack,
  redis,
  swh-core,
  swh-model,

  # Tests
  pytestCheckHook,
  pytest-mock,
}:

buildPythonPackage (finalAttrs: {
  pname = "swh-journal";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.softwareheritage.org";
    group = "swh";
    owner = "devel";
    repo = "swh-journal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SvI4WjheNqS2mphx9UY5i0nuempKc5iLF69XuEZ2yv8=";
  };

  build-system = [
    hatchling
    hatch-requirements-txt
    hatch-vcs
  ];

  dependencies = [
    confluent-kafka
    msgpack
    redis
    swh-core
    swh-model
  ];

  pythonImportsCheck = [ "swh.journal" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  disabledTests = [
    # Flaky - Working locally, not on the GH CI
    "test_client_with_deserializer"
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
    maintainers = with lib.maintainers; [ drupol ];
  };
})
