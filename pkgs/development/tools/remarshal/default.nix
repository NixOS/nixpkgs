{ stdenv, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "remarshal";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner  = "dbohdan";
    repo   = "remarshal";
    rev    = "v${version}";
    sha256 = "1wsgvzfp40lvly7nyyhv9prip4vi32rfc8kdji587jpw28zc1dfb";
  };

  propagatedBuildInputs = with python3Packages; [
    dateutil pytoml pyyaml
  ];

  meta = with stdenv.lib; {
    description = "Convert between TOML, YAML and JSON";
    license = licenses.mit;
    homepage = https://github.com/dbohdan/remarshal;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
  };
}
