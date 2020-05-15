{ stdenv
, pythonAtLeast
, buildPythonPackage
, fetchPypi
, isPy27
, fetchpatch
, click
, click-log
, click-threading
, requests_toolbelt
, requests
, requests_oauthlib # required for google oauth sync
, atomicwrites
, milksnake
, shippai
, hypothesis
, pytest
, pytest-localserver
, pytest-subtesthack
, setuptools_scm
}:

# Packaging documentation at:
# https://github.com/pimutils/vdirsyncer/blob/0.16.7/docs/packaging.rst
buildPythonPackage rec {
  version = "0.16.7";
  pname = "vdirsyncer";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "6c9bcfb9bcb01246c83ba6f8551cf54c58af3323210755485fc23bb7848512ef";
  };

  propagatedBuildInputs = [
    click click-log click-threading
    requests_toolbelt
    requests
    requests_oauthlib # required for google oauth sync
    atomicwrites
  ];

  nativeBuildInputs = [
    setuptools_scm
  ];

  checkInputs = [
    hypothesis
    pytest
    pytest-localserver
    pytest-subtesthack
  ];

  patches = [
    # Fixes for hypothesis: https://github.com/pimutils/vdirsyncer/pull/779
    (fetchpatch {
      url = "https://github.com/pimutils/vdirsyncer/commit/22ad88a6b18b0979c5d1f1d610c1d2f8f87f4b89.patch";
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
    make DETERMINISTIC_TESTS=true PYTEST_ARGS="--deselect=tests/system/cli/test_sync.py::test_verbosity" test
  '';
  # Tests started to fail lately, for any python version even as low as 3.5 but
  # if you enable the check, you'll see even severer errors with a higher then
  # 3.5 python version. Hence it's marked as broken for higher then 3.5 and the
  # checks are disabled unconditionally. As a general end user advice, use the
  # normal "unstable" `vdirsyncer` derivation, not this one.
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/pimutils/vdirsyncer";
    description = "Synchronize calendars and contacts";
    license = licenses.mit;
    # vdirsyncer (unstable) works with mainline python versions
    broken = (pythonAtLeast "3.6");
    maintainers = with maintainers; [ loewenheim ];
  };
}
