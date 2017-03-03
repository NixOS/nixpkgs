{ lib, pythonPackages
, withBatinfoPkg ? null
, withBernhardPkg ? null
, withBottlePkg ? null
, withCassandra-driverPkg ? null
, withCouchdbPkg ? null
, withDockerPkg ? null
, withElasticsearchPkg ? null
, withHddtempPkg ? null
, withInfluxdbPkg ? null
, withMatplotlibPkg ? null
, withNetifacesPkg ? null
, withNvidia-ml-pyPkg ? null
, withPikaPkg ? null
, withPotsdbPkg ? null
, withPy3sensorsPkg ? null
, withPy-cpuinfoPkg ? null
, withPymdstatPkg ? null
, withPysnmpPkg ? null
, withPystachePkg ? null
, withPyzmqPkg ? null
, withRequestsPkg ? null
, withScandirPkg ? null
, withStatsdPkg ? null
, withWifiPkg ? null
, withZeroconfPkg ? null
}:

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
  propagatedBuildInputs = with pythonPackages; [
    psutil setuptools bottle batinfo pkgs.hddtemp pysnmp
  ]
  ++ (if isNull withBatinfoPkg then [] else [withBatinfoPkg] )
  ++ (if isNull withBernhardPkg then [] else [withBernhardPkg] )
  ++ (if isNull withBottlePkg then [] else [withBottlePkg] )
  ++ (if isNull withCassandra-driverPkg then [] else [withCassandr]a)
  ++ (if isNull withCouchdbPkg then [] else [withCouchdbPkg] )
  ++ (if isNull withDockerPkg then [] else [withDockerPkg] )
  ++ (if isNull withElasticsearchPkg then [] else [withElasticsearchPkg] )
  ++ (if isNull withHddtempPkg then [] else [withHddtempPkg] )
  ++ (if isNull withInfluxdbPkg then [] else [withInfluxdbPkg] )
  ++ (if isNull withMatplotlibPkg then [] else [withMatplotlibPkg] )
  ++ (if isNull withNetifacesPkg then [] else [withNetifacesPkg] )
  ++ (if isNull withNvidia-ml-pyPkg then [] else [withNvidi]a)
  ++ (if isNull withPikaPkg then [] else [withPikaPkg] )
  ++ (if isNull withPotsdbPkg then [] else [withPotsdbPkg] )
  ++ (if isNull withPy3sensorsPkg then [] else [withPy3sensorsPkg] )
  ++ (if isNull withPy-cpuinfoPkg then [] else [withP]y)
  ++ (if isNull withPymdstatPkg then [] else [withPymdstatPkg] )
  ++ (if isNull withPysnmpPkg then [] else [withPysnmpPkg] )
  ++ (if isNull withPystachePkg then [] else [withPystachePkg] )
  ++ (if isNull withPyzmqPkg then [] else [withPyzmqPkg] )
  ++ (if isNull withRequestsPkg then [] else [withRequestsPkg] )
  ++ (if isNull withScandirPkg then [] else [withScandirPkg] )
  ++ (if isNull withStatsdPkg then [] else [withStatsdPkg] )
  ++ (if isNull withWifiPkg then [] else [withWifiPkg] )
  ++ (if isNull withZeroconfPkg then [] else [withZeroconfPkg] )
  ;

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

