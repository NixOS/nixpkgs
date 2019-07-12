{ buildPythonPackage, fetchFromGitHub, lib
, requests, retrying, six
, pytest, mock, vcrpy, responses, pytest-catchlog
}:

buildPythonPackage rec {
  pname = "scrapinghub";
  version = "2.1.1";

  # No tests in PyPi
  src = fetchFromGitHub {
    repo = "python-scrapinghub";
    owner = "scrapinghub";
    rev = version;
    sha256 = "0w5bg6326vya7b3nh8cfhp1v26n415r8k81qm57m9a1n936k327y";
  };

  propagatedBuildInputs = [ requests retrying six ];

  checkInputs = [ pytest mock vcrpy responses pytest-catchlog ];
  # Some tests seem to hit the network
  checkPhase = "py.test -k 'not items and not job and not logs and not samples and not spiders and not project and not retry and not requests'";

  meta = with lib; {
    description = "The scrapinghub is a Python library for communicating with the Scrapinghub API";
    license = licenses.bsd3;
    homepage = https://github.com/scrapinghub/python-scrapinghub;
    maintainers = with maintainers; [ mredaelli ];
  };
}
