{ lib, pythonPackages, fetchFromGitHub }:

pythonPackages.buildPythonApplication rec {
  pname = "patroni";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "zalando";
    repo = pname;
    rev = "v${version}";
    sha256 = "0w0mz4a1cyxdsqmv7jrkw163jll8ir5zmf93zcidlqx13knrk80g";
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
    pytest
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
