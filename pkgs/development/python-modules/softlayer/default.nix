{ stdenv
, lib
, buildPythonPackage
, click
, fetchFromGitHub
, mock
, prompt-toolkit
, ptable
, pygments
, pytestCheckHook
, pythonOlder
, requests
, sphinx
, testtools
, tkinter
, urllib3
, prettytable
, rich
, zeep
}:

buildPythonPackage rec {
  pname = "softlayer";
  version = "6.1.0";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = pname;
    repo = "softlayer-python";
    rev = "v${version}";
    sha256 = "sha256-T49KVAsgcAZySkaJi47IrFcMHGZvEkGDjPWsdMarzwM=";
  };

  postPatch = ''
    substituteInPlace setup.py \
        --replace 'rich == 12.3.0' 'rich >= 12.3.0'
  '';

  propagatedBuildInputs = [
    click
    prompt-toolkit
    ptable
    pygments
    requests
    urllib3
    prettytable
    rich
  ];

  checkInputs = [
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
    "tests/transports/soap_tests.py"
  ];

  pythonImportsCheck = [ "SoftLayer" ];

  meta = with lib; {
    description = "Python libraries that assist in calling the SoftLayer API";
    homepage = "https://github.com/softlayer/softlayer-python";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
