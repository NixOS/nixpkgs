{ stdenv
, buildPythonApplication
, fetchPypi
, gdb
, iana-etc
, libredirect
, flask
, flask-socketio
, flask-compress
, pygdbmi
, pygments
, gevent
, breakpointHook
, }:

buildPythonApplication rec {
  pname = "gdbgui";
  version = "0.13.1.1";

  buildInputs = [ gdb ];
  propagatedBuildInputs = [
    flask
    flask-socketio
    flask-compress
    pygdbmi
    pygments
    gevent
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ypxgkxwb443ndyrmsa7zx2hn0d9b3s7n2w49ngfghd3l8k0yvi2";
  };

  postPatch = ''
    echo ${version} > gdbgui/VERSION.txt
    # remove upper version bound
    sed -ie 's!, <.*"!"!' setup.py
  '';

  postInstall = ''
    wrapProgram $out/bin/gdbgui \
      --prefix PATH : ${stdenv.lib.makeBinPath [ gdb ]}
  '';

  # tests do not work without stdout/stdin
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A browser-based frontend for GDB";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ yrashk ];
  };
}
