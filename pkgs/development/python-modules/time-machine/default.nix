{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
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

  # Only use -mno-omit-leaf-frame-pointer where supported
  # https://github.com/adamchainz/time-machine/pull/692
  # FIXME: remove in next update
  patches = lib.optionals (!stdenv.hostPlatform.isx86 && !stdenv.hostPlatform.isAarch64) [
    (fetchpatch2 {
      url = "https://github.com/adamchainz/time-machine/commit/42b65d0bc3c08fc4647ecf3375b6119a2be56b34.patch?full_index=1";
      excludes = [ "docs/changelog.rst" ];
      hash = "sha256-dlmOk7zwHF7/SVawmrwXHc7+BEqBrk37uT7GcZwVz+E=";
    })
  ];

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
  ]
  ++ lib.optionals stdenv.hostPlatform.is32bit [
    # FIXME(time32)
    "distant_destination"
    "test_fuzz"
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
