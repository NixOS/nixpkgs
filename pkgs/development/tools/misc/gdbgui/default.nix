{ lib
, buildPythonApplication
, fetchPypi
, gdb
, eventlet
, flask-compress
, flask-socketio
, pygdbmi
, pygments
, }:

buildPythonApplication rec {
  pname = "gdbgui";

  version = "0.15.2.0";

  buildInputs = [ gdb ];
  propagatedBuildInputs = [
    eventlet
    flask-compress
    flask-socketio
    pygdbmi
    pygments
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-vmMlRmjFqhs3Vf+IU9IDtJzt4dZ0yIOmXIVOx5chZPA=";
  };

  postPatch = ''
    echo ${version} > gdbgui/VERSION.txt
    # relax version requirements
    sed -i 's/==.*$//' requirements.txt
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
