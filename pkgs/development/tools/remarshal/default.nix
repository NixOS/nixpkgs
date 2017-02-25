{ stdenv, pythonPackages, fetchFromGitHub }:

pythonPackages.buildPythonApplication rec {
  name = "remarshal-${version}";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner  = "dbohdan";
    repo   = "remarshal";
    rev    = "v${version}";
    sha256 = "0jslawpzghv3chamrfddnyn5p5068kjxy8d38fxvi5h06qgfb4wp";
  };

  propagatedBuildInputs = with pythonPackages; [
    dateutil
    pytoml
    pyyaml
  ];

  meta = with stdenv.lib; {
    description = "Convert between TOML, YAML and JSON";
    license = licenses.mit;
    homepage = https://github.com/dbohdan/remarshal;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
  };
}
