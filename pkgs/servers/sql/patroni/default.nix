{ lib
, pythonPackages
, fetchFromGitHub
, nixosTests
}:

pythonPackages.buildPythonApplication rec {
  pname = "patroni";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "zalando";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-gOjjE++hf3GOimvCxBR0jqqi3JNpbejLcWbLHpz2H4Q=";
  };

  propagatedBuildInputs = with pythonPackages; [
    boto3
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

  nativeCheckInputs = with pythonPackages; [
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
    description = "Template for PostgreSQL HA with ZooKeeper, etcd or Consul";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = teams.deshaw.members;
  };
}
