{ lib, python2Packages, fetchFromGitHub }:

let
  pgdbconn = python2Packages.buildPythonPackage rec {
    pname = "pgdbconn";
    version = "0.8.0";
    src = fetchFromGitHub {
      owner = "perseas";
      repo = "pgdbconn";
      rev = "v${version}";
      sha256 = "09r4idk5kmqi3yig7ip61r6js8blnmac5n4q32cdcbp1rcwzdn6z";
    };
    # The tests are impure (they try to access a PostgreSQL server)
    doCheck = false;
    propagatedBuildInputs = [
      python2Packages.psycopg2
      python2Packages.pytest
    ];
  };
in

python2Packages.buildPythonApplication {
  pname = "pyrseas";
  version = "0.8.0";
  src = fetchFromGitHub {
    owner = "perseas";
    repo = "Pyrseas";
    rev = "2e9be763e61168cf20d28bd69010dc5875bd7b97";
    sha256 = "1h9vahplqh0rzqjsdq64qqar6hj1bpbc6nl1pqwwgca56385br8r";
  };
  # The tests are impure (they try to access a PostgreSQL server)
  doCheck = false;
  propagatedBuildInputs = [
    python2Packages.psycopg2
    python2Packages.pytest
    python2Packages.pyyaml
    pgdbconn
  ];
  meta = {
    description = "A declarative language to describe PostgreSQL databases";
    homepage = "https://perseas.github.io/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ pmeunier ];
  };
}
