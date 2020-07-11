{ stdenv
, buildPythonPackage
, fetchPypi
, isPy27
, click
, click-log
, click-threading
, requests_toolbelt
, requests
, requests_oauthlib # required for google oauth sync
, atomicwrites
, hypothesis
, pytestCheckHook
, pytest-localserver
, pytest-subtesthack
, setuptools_scm
}:

buildPythonPackage rec {
  version = "0.16.8";
  pname = "vdirsyncer";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "bfdb422f52e1d4d60bd0635d203fb59fa7f613397d079661eb48e79464ba13c5";
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
    pytestCheckHook
    pytest-localserver
    pytest-subtesthack
  ];

  postPatch = ''
    substituteInPlace setup.py --replace "click>=5.0,<6.0" "click"
  '';

  preCheck = ''
    export DETERMINISTIC_TESTS=true
  '';

  disabledTests = [ "test_verbosity" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/pimutils/vdirsyncer";
    description = "Synchronize calendars and contacts";
    license = licenses.mit;
    maintainers = with maintainers; [ loewenheim ];
  };
}
