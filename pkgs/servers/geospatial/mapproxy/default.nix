{ lib
, python3
, fetchPypi
}:

with python3.pkgs;
buildPythonApplication rec {
  pname = "MapProxy";
  version = "3.0.1";
  src = fetchPypi {
  inherit pname version;
  hash = "sha256-2So0e5VDWde33bNksdhzdaiOp4XkHcyULeBifV5OtKM=";
  };
  prePatch = ''
    substituteInPlace mapproxy/util/ext/serving.py --replace "args = [sys.executable] + sys.argv" "args = sys.argv"
  '';
  propagatedBuildInputs = [
    boto3 # needed for caches service
    pillow
    pyyaml
    pyproj
    shapely
    gdal
    lxml
    setuptools
  ];
  # Tests are disabled:
  # 1) Dependency list is huge.
  #    https://github.com/mapproxy/mapproxy/blob/master/requirements-tests.txt
  #
  # 2) There are security issues with package Riak
  #    https://github.com/NixOS/nixpkgs/issues/33876
  #    https://github.com/NixOS/nixpkgs/pull/56480
  doCheck = false;
  meta = with lib; {
  description = "Open source proxy for geospatial data";
  homepage = "https://mapproxy.org/";
  license = licenses.asl20;
  maintainers = with maintainers; [ rakesh4g ];
  };
}
