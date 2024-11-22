{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  haversine,
  medallion,
  pytz,
  rapidfuzz,
  requests,
  simplejson,
  stix2-patterns,
  taxii2-client,
}:

buildPythonPackage rec {
  pname = "stix2";
  version = "3.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oasis-open";
    repo = "cti-python-stix2";
    rev = "refs/tags/v${version}";
    hash = "sha256-1bILZUZgPOWmFWRu4p/fmgi4QPEE1lFQH9mxoWd/saI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pytz
    requests
    simplejson
    stix2-patterns
  ];

  nativeCheckInputs = [
    pytestCheckHook
    haversine
    medallion
    rapidfuzz
    taxii2-client
  ];

  disabledTests = [
    # flaky tests
    "test_graph_equivalence_with_filesystem_source"
    "test_graph_similarity_with_filesystem_source"
    "test_object_similarity_prop_scores"
  ];

  pythonImportsCheck = [ "stix2" ];

  meta = with lib; {
    description = "Produce and consume STIX 2 JSON content";
    homepage = "https://stix2.readthedocs.io/en/latest/";
    changelog = "https://github.com/oasis-open/cti-python-stix2/blob/v${version}/CHANGELOG";
    license = licenses.bsd3;
    maintainers = with maintainers; [ PapayaJackal ];
  };
}
