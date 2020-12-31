{ lib, pythonPackages, fetchFromGitHub }:

pythonPackages.buildPythonApplication rec {
  pname = "patroni";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "zalando";
    repo = pname;
    rev = "v${version}";
    sha256 = "1xxqwdsr91ldfvvwbw0b9b02lhvgn0662k2mq5ib8cn4kas6am12";
  };

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
    maintainers = [ maintainers.limeytexan ];
  };
}
