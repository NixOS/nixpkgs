{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  hypothesis,
  pytestCheckHook,
  python-dateutil,
  setuptools,
  tokenize-rt,
}:

buildPythonPackage (finalAttrs: {
  pname = "time-machine";
  version = "3.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adamchainz";
    repo = "time-machine";
    tag = finalAttrs.version;
    hash = "sha256-9ocj5RsjmHtXjcueDJE4v9QvpeFXgPSNam1Wct0q89o=";
  };

  build-system = [ setuptools ];

  dependencies = [ python-dateutil ];

  optional-dependencies.cli = [ tokenize-rt ];

  nativeCheckInputs = [
    freezegun
    hypothesis
    pytestCheckHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.cli;

  disabledTests = [
    # https://github.com/adamchainz/time-machine/issues/405
    "test_destination_string_naive"
    # Assertion Errors related to Africa/Addis_Ababa
    "test_destination_datetime_tzinfo_zoneinfo_nested"
    "test_destination_datetime_tzinfo_zoneinfo_no_orig_tz"
    "test_destination_datetime_tzinfo_zoneinfo"
    "test_move_to_datetime_with_tzinfo_zoneinfo"
    "test_localtime_and_gmtime_match_datetime"
  ];

  pythonImportsCheck = [ "time_machine" ];

  meta = {
    description = "Travel through time in your tests";
    homepage = "https://github.com/adamchainz/time-machine";
    changelog = "https://github.com/adamchainz/time-machine/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
