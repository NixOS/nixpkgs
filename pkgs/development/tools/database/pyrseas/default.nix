{ lib, python3Packages, fetchFromGitHub }:

let
  pgdbconn = python3Packages.buildPythonPackage rec {
    pname = "pgdbconn";
    version = "0.8.0";
    src = fetchFromGitHub {
      owner = "perseas";
      repo = "pgdbconn";
      rev = "v${version}";
      hash = "sha256-39j2OcvhLtaYGJjYwlS1dCEtTQ7mxvOiHxHXWWaLJCc=";
    };
    # The tests are impure (they try to access a PostgreSQL server)
    doCheck = false;
    propagatedBuildInputs = [
      python3Packages.psycopg2
      python3Packages.pytest
    ];
  };
in

python3Packages.buildPythonApplication rec {
  pname = "pyrseas";
  version = "0.9.1";
  src = fetchFromGitHub {
    owner = "perseas";
    repo = "Pyrseas";
    rev = version;
    hash = "sha256-+MxnxvbLMxK1Ak+qKpKe3GHbzzC+XHO0eR7rl4ON9H4=";
  };
  # The tests are impure (they try to access a PostgreSQL server)
  doCheck = false;
  propagatedBuildInputs = [
    python3Packages.psycopg2
    python3Packages.pytest
    python3Packages.pyyaml
    pgdbconn
  ];
  meta = {
    description = "A declarative language to describe PostgreSQL databases";
    homepage = "https://perseas.github.io/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ pmeunier ];
  };
}
