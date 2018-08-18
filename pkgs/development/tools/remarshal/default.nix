{ stdenv, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "remarshal";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner  = "dbohdan";
    repo   = "remarshal";
    rev    = "v${version}";
    sha256 = "192r1mfd5yj6kg6fqmkjngdlgn25g5rkvm0p6xaflpvavnhvhnsj";
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
