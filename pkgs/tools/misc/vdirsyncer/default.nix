{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  version = "0.7.3";
  name = "vdirsyncer-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "https://pypi.python.org/packages/source/v/vdirsyncer/${name}.tar.gz";
    sha256 = "0ahi5ngqwsrv30bgziz35dx4gif7rbn9vqv340pigbzmywjxz1ry";
  };

  propagatedBuildInputs = with pythonPackages; [
    click click-log click-threading
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
