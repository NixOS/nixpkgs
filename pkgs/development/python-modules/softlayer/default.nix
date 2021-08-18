{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, ptable
, click
, requests
, prompt-toolkit
, pygments
, urllib3
, pytest
, pytest-cov
, mock
, sphinx
, testtools
, tkinter
}:

buildPythonPackage rec {
  pname = "softlayer";
  version = "5.9.7";
  disabled = isPy27;

  propagatedBuildInputs = [ ptable click requests prompt-toolkit pygments urllib3 ];

  checkInputs = [ pytest pytest-cov mock sphinx testtools tkinter ];

  checkPhase = ''
    pytest
  '';

  src = fetchFromGitHub {
    owner = "softlayer";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-72ZKc8WlVPs7HISHaAcZKM+ZLbiPbsOJpaNPdvP0kH8=";
  };

  meta = with lib; {
    description = "A set of Python libraries that assist in calling the SoftLayer API.";
    homepage = "https://github.com/softlayer/softlayer-python";
    license = licenses.mit;
  };
}
