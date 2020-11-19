{ stdenv
, buildPythonApplication
, fetchPypi
, gdb
, flask
, flask-socketio
, flask-compress
, pygdbmi
, pygments
, gevent
, gevent-websocket
, eventlet
, }:

buildPythonApplication rec {
  pname = "gdbgui";
  version = "0.13.2.1";

  buildInputs = [ gdb ];
  propagatedBuildInputs = [
    flask
    flask-socketio
    flask-compress
    pygdbmi
    pygments
    gevent
    gevent-websocket
    eventlet
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zn5wi47m8pn4amx574ryyhqvhynipxzyxbx0878ap6g36vh6l1h";
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
    homepage = "https://www.gdbgui.com/";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ yrashk ];
  };
}
