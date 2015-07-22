{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  version = "0.5.2";
  name = "vdirsyncer-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "https://github.com/untitaker/vdirsyncer/archive/${version}.tar.gz";
    sha256 = "02k6ijj0z0r08l50ignm2ngd4ax84l0r1wshh1is0wcfr70d94h9";
  };

  propagatedBuildInputs = with pythonPackages; [
    click
    lxml
    setuptools
    setuptools_scm
    requests_toolbelt
    requests2
    atomicwrites
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/untitaker/vdirsyncer;
    description = "Synchronize calendars and contacts";
    maintainers = with maintainers; [ matthiasbeyer jgeerds ];
    platforms = platforms.all;
    license = licenses.mit;
  };
}
