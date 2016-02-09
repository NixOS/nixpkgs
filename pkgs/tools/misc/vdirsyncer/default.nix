{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  version = "0.8.1";
  name = "vdirsyncer-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "https://pypi.python.org/packages/source/v/vdirsyncer/${name}.tar.gz";
    sha256 = "1abflqw6x30xd2dlj58cr5n62x98kc0ia9f9vr8l64k2z1fjlq78";
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
