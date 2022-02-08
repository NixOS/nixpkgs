{ lib
, buildPythonPackage
, fetchFromGitHub
, appdirs
, configargparse
, connection-pool
, datrie
, filelock
, GitPython
, jsonschema
, nbformat
, psutil
, pulp
, pyyaml
, ratelimiter
, smart-open
, stopit
, tabulate
, toposort
, wrapt
, pandas
, pytestCheckHook
, requests-mock
}:

buildPythonPackage rec {
  pname = "snakemake";
  version = "6.15.2";

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = pname;
    rev = "v${version}";
    sha256 = "1s56gv5bzf0y5dfzr4mh5m6b7nxqvbawnbw5h01pa9gfd7ppjrdr";
  };

  propagatedBuildInputs = [
    appdirs
    configargparse
    connection-pool
    datrie
    filelock
    GitPython
    jsonschema
    nbformat
    psutil
    pulp
    pyyaml
    ratelimiter
    smart-open
    stopit
    tabulate
    toposort
    wrapt
  ];

  checkInputs = [
    pandas
    pytestCheckHook
    requests-mock
  ];

  disabledTestPaths = [
    "tests/test_tes.py"
    "tests/test_tibanna.py"
  ];

  pythonImportsCheck = [ "snakemake" ];

  meta = with lib; {
    homepage = "https://snakemake.readthedocs.io/";
    description = "The Snakemake workflow management system is a tool to create reproducible and scalable data analyses.";
    license = licenses.mit;
    maintainers = with maintainers; [ wd15 ];
  };
}
