{ lib
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
}:

buildPythonPackage rec {
  pname = "softlayer";
  version = "5.9.8";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = pname;
    repo = "softlayer-python";
    rev = "v${version}";
    sha256 = "087kyl2yacvh12i4x3357659mgq4xycv8a4y9rl3rj57kp5jc6ah";
  };

  propagatedBuildInputs = [
    click
    prompt-toolkit
    ptable
    pygments
    requests
    urllib3
  ];

  checkInputs = [
    mock
    pytestCheckHook
    sphinx
    testtools
    tkinter
  ];

  pythonImportsCheck = [ "SoftLayer" ];

  meta = with lib; {
    description = "Python libraries that assist in calling the SoftLayer API";
    homepage = "https://github.com/softlayer/softlayer-python";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
