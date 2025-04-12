{
  lib,
  stdenv,
  fetchzip,
  qtbase,
  qtscxml,
  cmake,
  asciidoc,
  docbook_xsl,
  json_c,
  mesa_glu,
  libglut,
  trace-cmd,
  pkg-config,
  libtraceevent,
  libtracefs,
  freefont_ttf,
  wrapQtAppsHook,
  qtwayland,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kernelshark";
  version = "2.3.1";

  src = fetchzip {
    url = "https://git.kernel.org/pub/scm/utils/trace-cmd/kernel-shark.git/snapshot/kernelshark-v${finalAttrs.version}.tar.gz";
    hash = "sha256-KV8ahV2koX7OL1C42H5If14e7m54jv0DlZ1dNsVRUWE=";
  };

  outputs = [ "out" ];

  nativeBuildInputs = [
    pkg-config
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtscxml
    qtwayland
    json_c
    mesa_glu
    libglut
    libtraceevent
    libtracefs
    trace-cmd
  ];

  cmakeFlags = [
    "-D_INSTALL_PREFIX=${placeholder "out"}"
    "-D_POLKIT_INSTALL_PREFIX=${placeholder "out"}"
    "-DPKG_CONGIG_DIR=${placeholder "out"}/lib/pkgconfig"
    "-DTT_FONT_FILE=${freefont_ttf}/share/fonts/truetype/FreeSans.ttf"
  ];

  meta = with lib; {
    description = "GUI for trace-cmd which is an interface for the Linux kernel ftrace subsystem";
    homepage = "https://kernelshark.org/";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ basvandijk ];
  };
})
