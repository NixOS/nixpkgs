{ stdenv, mkDerivation, fetchgit, qtbase, cmake, json_c, mesa_glu, freeglut, trace-cmd, pkg-config }:
mkDerivation rec {
  pname = "kernelshark";
  version = "1.0.0";

  src = fetchgit (import ./src.nix);

  patches = [ ./fix-Makefiles.patch ];

  outputs = [ "out" "doc" ];

  preConfigure = "pushd kernel-shark";

  nativeBuildInputs = [ cmake ];

  buildInputs = [ qtbase json_c mesa_glu freeglut pkg-config ];

  cmakeFlags = [
    "-D_INSTALL_PREFIX=${placeholder "out"}"
    "-DTRACECMD_EXECUTABLE=${trace-cmd}/bin/trace-cmd"
    "-DTRACECMD_INCLUDE_DIR=${trace-cmd.dev}/include"
    "-DTRACECMD_LIBRARY=${trace-cmd.lib}/lib/libtracecmd.a"
    "-DTRACEEVENT_LIBRARY=${trace-cmd.lib}/lib/libtraceevent.a"
  ];

  preInstall = ''
    popd
    make install_gui_docs prefix=$doc
    pushd kernel-shark/build
  '';

  meta = with stdenv.lib; {
    description = "GUI for trace-cmd which is an interface for the Linux kernel ftrace subsystem";
    homepage    = http://kernelshark.org/;
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ basvandijk ];
  };
}
