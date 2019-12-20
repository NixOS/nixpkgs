{ stdenv, buildPythonPackage, fetchPypi, glibcLocales }:

buildPythonPackage rec {
  pname = "urwid";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0896f36060beb6bf3801cb554303fef336a79661401797551ba106d23ab4cd86";
  };

  # tests need to be able to set locale
  LC_ALL = "en_US.UTF-8";
  checkInputs = [ glibcLocales ];

  meta = with stdenv.lib; {
    description = "A full-featured console (xterm et al.) user interface library";
    homepage = http://excess.org/urwid;
    repositories.git = git://github.com/wardi/urwid.git;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ ];
  };
}
