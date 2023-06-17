{ lib
, stdenv
, buildPythonPackage
, click
, fetchFromGitHub
, mock
, prettytable
, prompt-toolkit
, ptable
, pygments
, pytestCheckHook
, pythonOlder
, requests
, rich
, sphinx
, testtools
, tkinter
, urllib3
, zeep
}:

buildPythonPackage rec {
  pname = "softlayer";
  version = "6.1.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = "softlayer-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ofl8MmGn70CJPuPZi0W0GJiMiceMNMACSNVKaOPdQN8=";
  };

  postPatch = ''
    substituteInPlace setup.py \
        --replace "rich ==" "rich >="
  '';

  propagatedBuildInputs = [
    click
    prettytable
    prompt-toolkit
    ptable
    pygments
    requests
    rich
    urllib3
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
    sphinx
    testtools
    tkinter
    zeep
  ];

  # Otherwise soap_tests.py will fail to create directory
  # Permission denied: '/homeless-shelter'
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTestPaths = [
    # Test fails with ConnectionError trying to connect to api.softlayer.com
    "tests/transports/soap_tests.py.unstable"
  ];

  pythonImportsCheck = [
    "SoftLayer"
  ];

  meta = with lib; {
    description = "Python libraries that assist in calling the SoftLayer API";
    homepage = "https://github.com/softlayer/softlayer-python";
    changelog = "https://github.com/softlayer/softlayer-python/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
