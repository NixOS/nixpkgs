{ lib
, buildPythonApplication
, fetchPypi
, gdb
, flask-socketio
, flask-compress
, pygdbmi
, pygments
, }:

buildPythonApplication rec {
  pname = "gdbgui";

  version = "0.15.0.1";


  buildInputs = [ gdb ];
  propagatedBuildInputs = [
    flask-socketio
    flask-compress
    pygdbmi
    pygments
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-bwrleLn3GBx4Mie2kujtaUo+XCALM+hRLySIZERlBg0=";
  };

  postPatch = ''
    echo ${version} > gdbgui/VERSION.txt
    # remove upper version bound
    sed -ie 's!,.*<.*!!' requirements.in
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
