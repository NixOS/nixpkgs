{ lib, fetchurl, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  version = "0.4.3";
  name = "vdirsyncer-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "https://github.com/untitaker/vdirsyncer/archive/${version}.tar.gz";
    sha256 = "0jrxmq8lq0dvqflmh42hhyvc3jjrg1cg3gzfhdcsskj9zz0m6wai";
  };

  pythonPath = with pythonPackages; [
    icalendar
    click
    requests
    lxml
    setuptools
    requests_toolbelt
    requests2
    atomicwrites
  ];

  meta = {
    homepage = https://github.com/untitaker/vdirsyncer;
    description = "Synchronize calendars and contacts";
    maintainers = [ lib.maintainers.matthiasbeyer ];
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
  };
}

