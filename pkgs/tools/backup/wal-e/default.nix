{
  lib,
  fetchFromGitHub,
  python3Packages,
  lzop,
  postgresql,
  pv,
}:

python3Packages.buildPythonApplication rec {
  pname = "wal-e";
  version = "1.1.1";

  namePrefix = "";

  src = fetchFromGitHub {
    owner = "wal-e";
    repo = "wal-e";
    rev = "v${version}";
    hash = "sha256-I6suHkAYzDtlNFNPH4SziY93Ryp+NTHkCBuojDvv+U4=";
  };

  # needs tox
  doCheck = false;

  propagatedBuildInputs =
    (with python3Packages; [
      boto
      gevent
      google-cloud-storage
    ])
    ++ [
      postgresql
      lzop
      pv
    ];

  meta = {
    description = "A Postgres WAL-shipping disaster recovery and replication toolkit";
    mainProgram = "wal-e";
    homepage = "https://github.com/wal-e/wal-e";
    maintainers = [ ];
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
}
