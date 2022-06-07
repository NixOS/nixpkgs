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
}:

buildPythonPackage rec {
  pname = "softlayer";
  version = "5.9.9";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = pname;
    repo = "softlayer-python";
    rev = "v${version}";
    sha256 = "sha256-LskPz5KXOi7olb3+DUP9uEFESQeo6ec/ZLx9B/w6Ni0=";
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
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "Python libraries that assist in calling the SoftLayer API";
    homepage = "https://github.com/softlayer/softlayer-python";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
