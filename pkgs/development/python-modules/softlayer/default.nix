{ lib
, buildPythonPackage
, fetchFromGitHub
, ptable
, click
, requests
, prompt_toolkit
, pygments
, urllib3
, pytest
, pytestcov
, mock
, sphinx
, testtools
}:

buildPythonPackage rec {
  pname = "softlayer-python";
  version = "5.8.4";

  propagatedBuildInputs = [ ptable click requests prompt_toolkit pygments urllib3 ];

  checkInputs = [ pytest pytestcov mock sphinx testtools ptable click requests prompt_toolkit pygments urllib3 ];

  checkPhase = ''
    pytest
  '';

  src = fetchFromGitHub {
    owner = "softlayer";
    repo = pname;
    rev = "v${version}";
    sha256 = "10kzi7kvvifr21a46q2xqsibs0bx5ys22nfym0bg605ka37vcz88";
  };

  meta = with lib; {
    description = "A set of Python libraries that assist in calling the SoftLayer API.";
    homepage = https://github.com/softlayer/softlayer-python;
    license = licenses.mit;
  };
}
