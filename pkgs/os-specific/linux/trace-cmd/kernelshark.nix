{ lib, mkDerivation, fetchgit, qtbase, cmake, asciidoc
, docbook_xsl, json_c, mesa_glu, freeglut, trace-cmd, pkg-config
, libtraceevent, libtracefs, freefont_ttf
}:

mkDerivation rec {
  pname = "kernelshark";
  version = "2.0.2";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/utils/trace-cmd/kernel-shark.git/";
    rev = "kernelshark-v${version}";
    sha256 = "0vy5wa1kccrxr973l870jy5hl6lac7sk3zyg3hxrwmivin1yf0cv";
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
