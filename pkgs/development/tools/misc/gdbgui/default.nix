{ lib
, buildPythonApplication
, fetchPypi
, gdb
, flask
, six
, bidict
, python-engineio
, python-socketio
, flask-socketio
, flask-compress
, pygdbmi
, pygments
, gevent
, gevent-websocket
, eventlet
, }:

let
  # gdbgui only works with the latest previous major version of flask-socketio,
  # which depends itself on the latest previous major versions of dependencies.
  python-engineio' = python-engineio.overridePythonAttrs (old: rec {
    version = "3.14.2";
    src = fetchPypi {
      inherit (old) pname;
      inherit version;
      sha256 = "119halljynqsgswlhlh750qv56js1p7j52sc0nbwxh8450zmbd7a";
    };
    propagatedBuildInputs = [ six ];
    doCheck = false;
  });
  python-socketio' = python-socketio.overridePythonAttrs (old: rec {
    version = "4.6.1";
    src = fetchPypi {
      inherit (old) pname;
      inherit version;
      sha256 = "047syhrrxh327p0fnab0d1zy25zijnj3gs1qg3kjpsy1jaj5l7yd";
    };
    propagatedBuildInputs = [ bidict python-engineio' ];
    doCheck = false;
  });
  flask-socketio' = flask-socketio.overridePythonAttrs (old: rec {
    version = "4.3.2";
    src = fetchPypi {
      inherit (old) pname;
      inherit version;
      sha256 = "0s2xs9kv9cbwy8bcxszhdwlcb9ldv0fj33lwilf5vypj0wsin01p";
    };
    propagatedBuildInputs = [ flask python-socketio' ];
    doCheck = false;
  });
in
buildPythonApplication rec {
  pname = "gdbgui";
  version = "0.14.0.2";

  buildInputs = [ gdb ];
  propagatedBuildInputs = [
    flask
    flask-socketio'
    flask-compress
    pygdbmi
    pygments
    gevent
    gevent-websocket
    eventlet
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "1v6wwsncgnhlg5c7gsmzcp52hfblfnz5kf5pk4d0zybflsxak02d";
  };

  postPatch = ''
    echo ${version} > gdbgui/VERSION.txt
    # remove upper version bound
    sed -ie 's!, <.*"!"!' setup.py
    sed -i 's/greenlet==/greenlet>=/' setup.py
  '';

  postInstall = ''
    wrapProgram $out/bin/gdbgui \
      --prefix PATH : ${lib.makeBinPath [ gdb ]}
  '';

  # tests do not work without stdout/stdin
  doCheck = false;

  meta = with lib; {
    description = "A browser-based frontend for GDB";
    homepage = "https://www.gdbgui.com/";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ yrashk dump_stack ];
  };
}
