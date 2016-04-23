{ stdenv, fetchurl, pythonPackages, glibcLocales }:

# Packaging documentation at:
# https://github.com/untitaker/vdirsyncer/blob/master/docs/packaging.rst
pythonPackages.buildPythonApplication rec {
  version = "0.10.0";
  name = "vdirsyncer-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "https://pypi.python.org/packages/0b/fb/c42223e1e9169e4770194e62143d431755724b080d8cb77f14705b634815/vdirsyncer-0.10.0.tar.gz";
    sha256 = "1gf86sbd6w0w4zayh9r3irlp5jwrzbjikjc0vs5zkdpa5c199f78";
  };

  propagatedBuildInputs = with pythonPackages; [
    click click-log click-threading
    requests_toolbelt
    requests2
    atomicwrites
  ];

  buildInputs = with pythonPackages; [hypothesis pytest pytest-localserver pytest-subtesthack setuptools_scm ] ++ [ glibcLocales ];

  LC_ALL = "en_US.utf8";

  checkPhase = ''
    make DETERMINISTIC_TESTS=true test
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/pimutils/vdirsyncer;
    description = "Synchronize calendars and contacts";
    maintainers = with maintainers; [ matthiasbeyer jgeerds DamienCassou ];
    platforms = platforms.all;
    license = licenses.mit;
  };
}
