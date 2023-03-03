{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, click
, click-log
, click-threading
, requests-toolbelt
, requests
, atomicwrites
, hypothesis
, pytestCheckHook
, pytest-subtesthack
, setuptools-scm
, aiostream
, aiohttp-oauthlib
, aiohttp
, pytest-asyncio
, trustme
, aioresponses
, vdirsyncer
, testers
}:

buildPythonPackage rec {
  pname = "vdirsyncer";
  version = "0.19.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256:0995bavlv8s9j0127ncq3yzy5p72lam9qgpswyjfanc6l01q87lf";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "click-log>=0.3.0, <0.4.0" "click-log>=0.3.0, <0.5.0"

    sed -i -e '/--cov/d' -e '/--no-cov/d' setup.cfg
  '';

  propagatedBuildInputs = [
    atomicwrites
    click
    click-log
    click-threading
    requests
    requests-toolbelt
    aiostream
    aiohttp
    aiohttp-oauthlib
  ];

  nativeBuildInputs = [
    setuptools-scm
  ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
    pytest-subtesthack
    pytest-asyncio
    trustme
    aioresponses
  ];

  preCheck = ''
    export DETERMINISTIC_TESTS=true
  '';

  disabledTests = [
    "test_create_collections" # Flaky test exceeds deadline on hydra: https://github.com/pimutils/vdirsyncer/issues/837
    "test_request_ssl"
    "test_verbosity"
  ];

  passthru.tests.version = testers.testVersion { package = vdirsyncer; };

  meta = with lib; {
    homepage = "https://github.com/pimutils/vdirsyncer";
    description = "Synchronize calendars and contacts";
    license = licenses.mit;
    maintainers = with maintainers; [ loewenheim ];
  };
}
