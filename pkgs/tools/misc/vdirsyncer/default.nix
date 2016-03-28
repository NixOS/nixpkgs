{ stdenv, fetchurl, pythonPackages, glibcLocales }:

# Packaging documentation at:
# https://github.com/untitaker/vdirsyncer/blob/master/docs/packaging.rst
pythonPackages.buildPythonApplication rec {
  version = "0.9.3";
  name = "vdirsyncer-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "https://pypi.python.org/packages/source/v/vdirsyncer/${name}.tar.gz";
    sha256 = "1wjhzjfcvwz68j6wc5cmjsw69ggwcpfy7jp7z7q6fnwwp4dr98lc";
  };

  propagatedBuildInputs = with pythonPackages; [
    click click-log click-threading
    lxml
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
    maintainers = with maintainers; [ matthiasbeyer jgeerds ];
    platforms = platforms.all;
    license = licenses.mit;
  };
}
