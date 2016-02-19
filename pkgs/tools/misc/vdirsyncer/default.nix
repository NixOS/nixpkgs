{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  version = "0.9.0";
  name = "vdirsyncer-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "https://pypi.python.org/packages/source/v/vdirsyncer/${name}.tar.gz";
    sha256 = "0s9awjr9v60rr80xcpwmdhkf4v1yqnydahjmxwvxmh64565is465";
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

  # Unfortunately, checking this package seems a bit too complex
  # https://github.com/NixOS/nixpkgs/pull/13098#issuecomment-185914025
  # https://github.com/untitaker/vdirsyncer/issues/334#issuecomment-185872854
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/untitaker/vdirsyncer;
    description = "Synchronize calendars and contacts";
    maintainers = with maintainers; [ matthiasbeyer jgeerds ];
    platforms = platforms.all;
    license = licenses.mit;
  };
}
