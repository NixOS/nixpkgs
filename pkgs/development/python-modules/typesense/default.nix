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

buildPythonPackage rec {
  pname = "typesense";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "typesense";
    repo = "typesense-python";
    tag = "v${version}";
    hash = "sha256-vo9DW4kinb00zWW4yX8ibyelQxW3eVabn+oMddPEd18=";
  };

  patches = [
    # See <https://github.com/typesense/typesense-python/pull/103>.
    ./linux-only-metrics.patch
    ./generated-temp-path.patch
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
  disabledTests = [ "import_typing_extensions" ];

  __darwinAllowLocalNetworking = true;

  preCheck = ''
    TYPESENSE_API_KEY="xyz" \
    TYPESENSE_DATA_DIR="$(mktemp -d)" \
    typesense-server &

    typesense_pid=$!

    # Wait for typesense to finish starting.
    timeout 20 bash -c '
      while ! curl -s --fail localhost:8108/health; do sleep 1; done
    ' || false
  '';
  postCheck = ''
    kill $typesense_pid
  '';

  pythonImportsCheck = [ "typesense" ];

  meta = {
    description = "Python client for Typesense, an open source and typo tolerant search engine";
    homepage = "https://github.com/typesense/typesense-python";
    license = lib.licenses.asl20;
    teams = [ lib.teams.ngi ];
  };
}
