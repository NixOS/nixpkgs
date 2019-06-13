{ stdenv, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "remarshal";
  version = "0.9.1";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "564ffe9cbde85bd28a9c184b90c764abd2003abd6101a30802262198b5c7fc40";
  };

  propagatedBuildInputs = with python3Packages; [
    dateutil pytoml pyyaml
  ];

  meta = with stdenv.lib; {
    description = "Convert between TOML, YAML and JSON";
    license = licenses.mit;
    homepage = https://github.com/dbohdan/remarshal;
    maintainers = with maintainers; [ offline ];
  };
}
