{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage (rec {
  pname = "urwid";
  version = "1.3.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18cnd1wdjcas08x5qwa5ayw6jsfcn33w4d9f7q3s29fy6qzc1kng";
  };

  meta = with stdenv.lib; {
    description = "A full-featured console (xterm et al.) user interface library";
    homepage = http://excess.org/urwid;
    repositories.git = git://github.com/wardi/urwid.git;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ garbas ];
  };
})
