{ lib, buildPythonPackage, fetchPypi, callPackage
, future, pbr, cliff, subunit, fixtures, testtools, pyyaml, voluptuous
}:

buildPythonPackage rec {
  pname = "stestr";
  version = "3.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fb492cbdf3d3fdd6812645804efc84a99a68bb60dd7705f15c1a2949c8172bc4";
  };

  propagatedBuildInputs = [
    future
    pbr
    cliff
    subunit
    fixtures
    testtools
    pyyaml
    voluptuous
  ];

  checkPhase = ''
    $out/bin/stestr --version | grep ${version} > /dev/null
  '';

  meta = with lib; {
    description = "A parallel Python test runner built around subunit";
    downloadPage = "https://pypi.org/project/stestr/";
    homepage = "https://github.com/mtreinish/stestr/";
    license = licenses.asl20;
    maintainers = with maintainers; [ superherointj ];
  };
}
