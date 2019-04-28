{ stdenv, mkDerivation, fetchgit, qtbase, cmake, json_c, mesa_glu, freeglut, trace-cmd }:
let
  srcSpec = import ./src.nix;
  shortRev = builtins.substring 0 7 srcSpec.rev;
in mkDerivation rec {
  pname = "kernelshark";
  version = "0.9.8-${shortRev}";

  src = fetchgit srcSpec;

  sourceRoot = "trace-cmd-${shortRev}/kernel-shark";

  patches = [ ./fix-kernel-shark-CMakeLists.txt.patch ];
  patchFlags = [ "-p2" ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ qtbase json_c mesa_glu freeglut ];

  cmakeFlags = [
    "-D_INSTALL_PREFIX=${placeholder "out"}"
    "-DTRACECMD_BIN_DIR=${trace-cmd}/bin"
    "-DTRACECMD_INCLUDE_DIR=${trace-cmd.dev}/include/trace-cmd"
    "-DTRACECMD_LIBRARY_DIR=${trace-cmd.lib}/lib"
    "-DTRACEEVENT_INCLUDE_DIR=${trace-cmd.dev}/include/trace-cmd"
    "-DTRACEEVENT_LIBRARY_DIR=${trace-cmd.lib}/lib"
  ];

  meta = with stdenv.lib; {
    description = "GUI for trace-cmd which is an interface for the Linux kernel ftrace subsystem";
    homepage    = http://kernelshark.org/;
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ basvandijk ];
  };
}
