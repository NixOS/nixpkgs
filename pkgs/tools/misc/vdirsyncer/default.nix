{ stdenv, fetchurl, pythonPackages, glibcLocales }:

# Packaging documentation at:
# https://github.com/untitaker/vdirsyncer/blob/master/docs/packaging.rst
pythonPackages.buildPythonApplication rec {
  version = "0.11.0";
  name = "vdirsyncer-${version}";

  src = fetchurl {
    url = "mirror://pypi/v/vdirsyncer/${name}.tar.gz";
    sha256 = "1bf0vk29qdswar0q4267aamfriq3134302i2p3qcqxpmmcwx3qfv";
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
