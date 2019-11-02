{ lib, buildPythonPackage, fetchFromGitHub, update-dotdee, simpleeval, dateutil }:

buildPythonPackage rec {
  pname = "rotate-backups";
  version = "6.0";

  src = fetchFromGitHub {
    owner = "xolox";
    repo = "python-rotate-backups";
    rev = version;
    sha256 = "0i59qfv1cfm0ss63ab2nrkn5wr4rxpqqmvfd7pf9c3pl9dbfq20c";
  };

  propagatedBuildInputs = [ update-dotdee simpleeval dateutil ];

  meta = with lib; {
    description = "Simple command line interface for backup rotation";
    homepage = https://github.com/xolox/python-rotate-backups;
    license = licenses.mit;
    maintainers = with maintainers; [ eyjhb ];
  };
}

