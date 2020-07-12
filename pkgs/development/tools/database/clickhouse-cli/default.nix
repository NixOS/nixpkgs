{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "clickhouse-cli";
  version = "0.3.6";

  disabled = python3Packages.isPy27;

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "0w3bzfnmh90zywbrvzxxh9bfwf92whhx24mywa6d6iix01vmcf7v";
  };

  propagatedBuildInputs = with python3Packages; [
    click
    prompt_toolkit
    pygments
    requests
    sqlparse
  ];

  checkPhase = ''
    $out/bin/clickhouse-cli --help > /dev/null
  '';

  meta = with lib; {
    homepage = "https://github.com/hatarist/clickhouse-cli";
    description = "A third-party client for the Clickhouse DBMS server.";
    license = licenses.mit;
    maintainers = with maintainers; [ johnpyp ];
  };
}
