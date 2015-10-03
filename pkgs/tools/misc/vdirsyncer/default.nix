{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  version = "0.6.0";
  name = "vdirsyncer-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "https://pypi.python.org/packages/source/v/vdirsyncer/${name}.tar.gz";
    sha256 = "1mb0pws5vsgnmyp5dp5m5jvgl6jcvdamxjz7wmgvxkw6n1vrcahd";
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
