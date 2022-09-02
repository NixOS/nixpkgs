{ lib
, pythonPackages
, fetchFromGitHub
, nixosTests
}:

pythonPackages.buildPythonApplication rec {
  pname = "patroni";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "zalando";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cBkiBrty/6A3rIv9A1oh8GvPjwxhHwYEKuDIsNzHw1g=";
  };

  # cdiff renamed to ydiff; remove when patroni source reflects this.
  postPatch = ''
    for i in requirements.txt patroni/ctl.py tests/test_ctl.py; do
      substituteInPlace $i --replace cdiff ydiff
    done
  '';

  propagatedBuildInputs = with pythonPackages; [
    boto
    click
    consul
    dnspython
    kazoo
    kubernetes
    prettytable
    psutil
    psycopg2
    pysyncobj
    python-dateutil
    python-etcd
    pyyaml
    tzlocal
    urllib3
    ydiff
  ];

  checkInputs = with pythonPackages; [
    flake8
    mock
    pytestCheckHook
    pytest-cov
    requests
  ];

  # Fix tests by preventing them from writing to /homeless-shelter.
  preCheck = "export HOME=$(mktemp -d)";

  pythonImportsCheck = [ "patroni" ];

  passthru.tests = {
    patroni = nixosTests.patroni;
  };

  meta = with lib; {
    homepage = "https://patroni.readthedocs.io/en/latest/";
    description = "A Template for PostgreSQL HA with ZooKeeper, etcd or Consul";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = teams.deshaw.members;
  };
}
