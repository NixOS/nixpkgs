{
  stdenv,
  lib,
  fetchFromGitLab,
  cmake,
  pkg-config,
  libdrm,
  libGL,
  atkmm,
  pcre,
  gtkmm4,
  pugixml,
  mesa,
  pciutils,
}:

stdenv.mkDerivation rec {
  pname = "adriconf";
  version = "2.7.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mesa";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-GRmra4P30EW9/WrG84HXYC3Rk4RD+BhuWtsSXvY/5Rk=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    libdrm
    libGL
    atkmm
    pcre
    gtkmm4
    pugixml
    mesa
    pciutils
  ];

  cmakeFlags = [ "-DENABLE_UNIT_TESTS=off" ];

  postInstall = ''
    install -Dm444 ../flatpak/org.freedesktop.adriconf.metainfo.xml \
      -t $out/share/metainfo/
    install -Dm444 ../flatpak/org.freedesktop.adriconf.desktop \
      -t $out/share/applications/
    install -Dm444 ../flatpak/org.freedesktop.adriconf.png \
      -t $out/share/icons/hicolor/256x256/apps/
  '';

  meta = with lib; {
    homepage = "https://gitlab.freedesktop.org/mesa/adriconf/";
    description = "A GUI tool used to configure open source graphics drivers";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ muscaln ];
    platforms = platforms.linux;
    mainProgram = "adriconf";
  };
}
