{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  pytestCheckHook,
  typesense,
  curl,
  pytest-mock,
  requests-mock,
  python-dotenv,
  faker,
  isort,
}:

buildPythonPackage (finalAttrs: {
  pname = "typesense";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "typesense";
    repo = "typesense-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b3t4l02tOiSMrkqZACV6l5f+Kb5Wfcnq9ZZCld1SKBU=";
  };

  patches = [
    # See <https://github.com/typesense/typesense-python/pull/132>.
    # See <https://github.com/typesense/typesense-python/pull/133>.
    ./0001-linux-only-metrics.patch
    ./0002-generated-temp-path.patch
    ./0003-tests-fix-rule_id.patch
    ./0004-test-gate-v30-collection-schema-expectations.patch
  ];

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [
    pytestCheckHook
    typesense
    curl
    pytest-mock
    requests-mock
    python-dotenv
    faker
    isort
  ];
  disabledTestMarks = [ "open_ai" ];
  disabledTests = [
    "import_typing_extensions"
    # tests/operations_test.py::test_snapshot_async fails when tests are run
    # in parallel due to writing to the shared /tmp directory on macOS
    "test_snapshot_async"
  ];

  __darwinAllowLocalNetworking = true;

  # For darwin, the nix sandbox doesn't isolate loopback interfaces like linux does.
  # So nixpkgs-review builds of python3.x will collide on the hardcoded port 8108.
  # So for tests patch it to use random port.
  preCheck = ''
    export TYPESENSE_PORT=$(( 10000 + $$ % 30000 ))
    export PEERING_PORT=$(( TYPESENSE_PORT - 1 ))
    find tests -type f -exec sed -i "s/8108/$TYPESENSE_PORT/g" {} +

    TYPESENSE_API_KEY="xyz" \
    TYPESENSE_DATA_DIR="$(mktemp -d)" \
    typesense-server --api-port=$TYPESENSE_PORT --peering-port=$PEERING_PORT &

    typesense_pid=$!

    # Ensure typesense-server is killed even if tests fail
    trap "kill $typesense_pid" EXIT

    # Wait for typesense to finish starting.
    timeout 20 bash -c "
      while ! curl -s --fail localhost:$TYPESENSE_PORT/health; do sleep 1; done
    " || false
  '';

  pythonImportsCheck = [ "typesense" ];

  meta = {
    description = "Python client for Typesense, an open source and typo tolerant search engine";
    homepage = "https://github.com/typesense/typesense-python";
    license = lib.licenses.asl20;
    teams = [ lib.teams.ngi ];
    # on x86_64-darwin the typesense server doesn't start
    badPlatforms = [ "x86_64-darwin" ];
  };
})
