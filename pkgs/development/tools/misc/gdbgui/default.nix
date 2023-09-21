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

  version = "0.15.1.0";

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
    sha256 = "sha256-YcD3om7N6yddm02It6/fjXDsVHG0Cs46fdGof0PMJXM=";
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
