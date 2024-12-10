{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

let
  pgdbconn = python3Packages.buildPythonPackage rec {
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

    propagatedBuildInputs = with python3Packages; [
      psycopg2
      pytest
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
    sha256 = "sha256-+MxnxvbLMxK1Ak+qKpKe3GHbzzC+XHO0eR7rl4ON9H4=";
  };

  propagatedBuildInputs = with python3Packages; [
    psycopg2
    pytest
    pyyaml
    pgdbconn
  ];

  # The tests are impure (they try to access a PostgreSQL server)
  doCheck = false;

  meta = {
    description = "A declarative language to describe PostgreSQL databases";
    homepage = "https://perseas.github.io/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ pmeunier ];
  };
}
