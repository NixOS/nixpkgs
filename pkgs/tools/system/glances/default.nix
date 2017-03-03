{ pythonPackages }:

pythonPackages.buildPythonPackage rec {
  name = "glances-${version}";
  version = "2.8.2";
  disabled = isPyPy;

  src = pkgs.fetchFromGitHub {
    owner = "nicolargo";
    repo = "glances";
    rev = "v${version}";
    sha256 = "1jwaq9k6q8wn197wadiwid7d8aik24rhsypmcl5q0jviwkhhiri9";
  };

  doCheck = false;

  buildInputs = with pythonPackages; [ unittest2 ];
  propagatedBuildInputs = with pythonPackages; [ psutil setuptools bottle batinfo pkgs.hddtemp pysnmp ];

  preConfigure = ''
    sed -i 's/data_files\.append((conf_path/data_files.append(("etc\/glances"/' setup.py;
  '';

  meta = {
    homepage = "http://nicolargo.github.io/glances/";
    description = "Cross-platform curses-based monitoring tool";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ koral ];
  };
};

