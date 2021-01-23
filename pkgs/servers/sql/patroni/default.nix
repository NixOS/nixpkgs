{ lib, pythonPackages, fetchFromGitHub }:

pythonPackages.buildPythonApplication rec {
  pname = "patroni";
  version = "1.6.5";

  src = fetchFromGitHub {
    owner = "zalando";
    repo = pname;
    rev = "v${version}";
    sha256 = "0iw0ra9fya4bf1vkjq3w5kij4x46yinb90v015pi9c6qfpancfdj";
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
    dns
    kazoo
    kubernetes
    prettytable
    psutil
    psycopg2
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
    pytestcov
    requests
  ];

  # Fix tests by preventing them from writing to /homeless-shelter.
  preCheck = "export HOME=$(mktemp -d)";

  meta = with lib; {
    homepage = "https://patroni.readthedocs.io/en/latest/";
    description = "A Template for PostgreSQL HA with ZooKeeper, etcd or Consul";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = teams.deshaw.members;
  };
}
