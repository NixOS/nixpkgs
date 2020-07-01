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
, }:

buildPythonApplication rec {
  pname = "gdbgui";
  version = "0.13.2.0";

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
    sha256 = "0m1fnwafzrpk77yj3p26vszlz11cv4g2lj38kymk1ilcifh4gqw0";
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
