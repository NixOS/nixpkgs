{ stdenv
, lib
, buildPythonPackage
, click
, fetchFromGitHub
, prettytable
, prompt-toolkit
, pygments
, pytestCheckHook
, pythonOlder
, requests
, rich
, softlayer-zeep
, tkinter
, urllib3
}:

buildPythonPackage rec {
  pname = "softlayer";
  version = "unstable-2022-05-31";
  disabled = pythonOlder "3.6";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = pname;
    repo = "softlayer-python";
    rev = "dae2ec73563a740c4670cc0718fd4b90c6d42eed";
    hash = "sha256-JfdCm+Q40Nrt73R9w9bNMoUMrhDPP6Do0Lj1tXaznpw=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "==" ">="
  '';

  propagatedBuildInputs = [
    click
    prettytable
    prompt-toolkit
    pygments
    requests
    rich
    urllib3
  ];

  checkInputs = [
    pytestCheckHook
    softlayer-zeep
    tkinter
  ];

  disabledTestPaths = [
    # requires network access
    "tests/transports/soap_tests.py"
  ];

  pythonImportsCheck = [ "SoftLayer" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Python libraries that assist in calling the SoftLayer API";
    homepage = "https://github.com/softlayer/softlayer-python";
    changelog = "https://github.com/softlayer/softlayer-python/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
