{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "timeslot";
  version = "0.1.2";

  # pypi distribution doesn't include tests, so build from source instead
  src = fetchFromGitHub {
    owner = "ErikBjare";
    repo = pname;
    rev = "af35445e96cbb2f3fb671a75aac6aa93e4e7e7a6";
    sha256 = "sha256-GEhg2iMsYMfalT7L9TCd1KHU6oa/wTl5m3mRC0zOH9Q=";
  };

  format = "pyproject";

  disabled = pythonOlder "3.6";

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [
    # The pyproject.toml specifies the flag `--cov=timeslot`,
    # This causes an error when running without pytest-cov,
    # so use this flag to override that option, as we don't need coverage.
    "--override-ini addopts=''"
  ];

  pythonImportsCheck = [ "timeslot" ];

  meta = with lib; {
    description = "Data type for representing time slots with a start and end";
    homepage = "https://github.com/ErikBjare/timeslot";
    maintainers = with maintainers; [ huantian ];
    license = licenses.mit;
  };
}
