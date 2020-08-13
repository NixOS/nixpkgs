{ stdenv, buildPythonPackage, fetchPypi, glibcLocales }:

buildPythonPackage rec {
  pname = "urwid";
  version = "2.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09nmi2nmvpcmbh3w3fb0dn0c7yp7r20i5pfcr6q722xh6mp8cw3q";
  };

  # tests need to be able to set locale
  LC_ALL = "en_US.UTF-8";
  checkInputs = [ glibcLocales ];

  meta = with stdenv.lib; {
    description = "A full-featured console (xterm et al.) user interface library";
    homepage = "http://excess.org/urwid";
    repositories.git = "git://github.com/wardi/urwid.git";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ ];
  };
}
