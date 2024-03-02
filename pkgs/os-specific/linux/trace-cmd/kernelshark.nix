{ lib, mkDerivation, fetchzip, qtbase, cmake, asciidoc
, docbook_xsl, json_c, mesa_glu, freeglut, trace-cmd, pkg-config
, libtraceevent, libtracefs, freefont_ttf
}:

mkDerivation rec {
  pname = "kernelshark";
  version = "2.2.1";

  src = fetchzip {
    url = "https://git.kernel.org/pub/scm/utils/trace-cmd/kernel-shark.git/snapshot/kernelshark-v${version}.tar.gz";
    hash = "sha256-V25IzPDOt6V03wgIa/AJ0T8mRaGmXYuMCcvbSOKleY0=";
  };

  outputs = [ "out" ];

  nativeBuildInputs = [ pkg-config cmake ];

  buildInputs = [ qtbase json_c mesa_glu freeglut libtraceevent libtracefs trace-cmd ];

  cmakeFlags = [
    "-D_INSTALL_PREFIX=${placeholder "out"}"
    "-D_POLKIT_INSTALL_PREFIX=${placeholder "out"}"
    "-DPKG_CONGIG_DIR=${placeholder "out"}/lib/pkgconfig"
    "-DTT_FONT_FILE=${freefont_ttf}/share/fonts/truetype/FreeSans.ttf"
  ];

  meta = with lib; {
    description = "GUI for trace-cmd which is an interface for the Linux kernel ftrace subsystem";
    homepage    = "https://kernelshark.org/";
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ basvandijk ];
  };
}
