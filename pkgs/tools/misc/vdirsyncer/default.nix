{ lib, fetchurl, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  version = "0.4.2";
  name = "vdirsyncer-${version}";
  namePrefix = "";

  src = fetchurl {
    url = https://github.com/untitaker/vdirsyncer/archive/0.4.2.tar.gz;
    sha256 = "008181mglbrp5jsvpxr59b6w4mw26h4s4gwij152i47mfbrizsl4";
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

