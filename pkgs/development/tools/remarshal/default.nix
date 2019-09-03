{ stdenv, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "remarshal";
  version = "0.10.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1prpczb8q996i5sf27vfmp0nv85zwsiajnf9jbjkhm0k21wfvmdd";
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
