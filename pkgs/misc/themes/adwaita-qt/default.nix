{ mkDerivation, lib, fetchFromGitHub, cmake, ninja, qtbase }:

mkDerivation rec {
  pname = "adwaita-qt";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "FedoraQt";
    repo = pname;
    rev = version;
    sha256 = "1jlh4l3sxiwglgx6h4aqi364gr4xipmn09bk88cp997r9sm8jcp9";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qtbase
  ];

  postPatch = ''
    # Fix plugin dir
    substituteInPlace style/CMakeLists.txt \
       --replace "DESTINATION \"\''${QT_PLUGINS_DIR}/styles" "DESTINATION \"$qtPluginPrefix/styles"
  '';

  meta = with lib; {
    description = "A style to bend Qt applications to look like they belong into GNOME Shell";
    homepage = https://github.com/FedoraQt/adwaita-qt;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ worldofpeace ];
    platforms = platforms.linux;
  };
}
