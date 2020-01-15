{ lib, python3Packages, fetchpatch }:

# Packaging documentation at:
# https://github.com/pimutils/vdirsyncer/blob/0.16.7/docs/packaging.rst
python3Packages.buildPythonApplication rec {
  version = "0.16.7";
  pname = "vdirsyncer";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "6c9bcfb9bcb01246c83ba6f8551cf54c58af3323210755485fc23bb7848512ef";
  };

  propagatedBuildInputs = with python3Packages; [
    click click-log click-threading
    requests_toolbelt
    requests
    requests_oauthlib # required for google oauth sync
    atomicwrites
  ];

  nativeBuildInputs = with python3Packages; [ setuptools_scm ];

  checkInputs = with python3Packages; [ hypothesis pytest pytest-localserver pytest-subtesthack ];

  patches = [
    # Fixes for hypothesis: https://github.com/pimutils/vdirsyncer/pull/779
    (fetchpatch {
      url = https://github.com/pimutils/vdirsyncer/commit/22ad88a6b18b0979c5d1f1d610c1d2f8f87f4b89.patch;
      sha256 = "0dbzj6jlxhdidnm3i21a758z83sdiwzhpd45pbkhycfhgmqmhjpl";
    })
  ];

  postPatch = ''
    # Invalid argument: 'perform_health_check' is not a valid setting
    substituteInPlace tests/conftest.py \
      --replace "perform_health_check=False" ""
    substituteInPlace tests/unit/test_repair.py \
      --replace $'@settings(perform_health_check=False)  # Using the random module for UIDs\n' ""
  '';

  checkPhase = ''
    make DETERMINISTIC_TESTS=true test
  '';

  meta = with lib; {
    homepage = https://github.com/pimutils/vdirsyncer;
    description = "Synchronize calendars and contacts";
    license = licenses.mit;
    maintainers = with maintainers; [ loewenheim ];
  };
}
