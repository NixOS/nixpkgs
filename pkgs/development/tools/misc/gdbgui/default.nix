{
  lib,
  buildPythonApplication,
  fetchPypi,
  gdb,
  eventlet,
  flask-compress,
  flask-socketio,
  pygdbmi,
  pygments,
}:

buildPythonApplication rec {
  pname = "gdbgui";

  version = "0.15.3.0";
  format = "setuptools";

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
    hash = "sha256-/HyFE0JnoN03CDyCQCo/Y9RyH4YOMoeB7khReIb8t7Y=";
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

  meta = {
    description = "Browser-based frontend for GDB";
    mainProgram = "gdbgui";
    homepage = "https://www.gdbgui.com/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      yrashk
      dump_stack
    ];
  };
}
