{ stdenv, fetchFromGitHub, cmake, ninja, qtbase }:

stdenv.mkDerivation rec {
  pname = "adwaita-qt";
  version = "1.0.91";

  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "FedoraQt";
    repo = pname;
    rev = version;
    sha256 = "1d6ldw0hlvsgrxw5dvp121jkcgibinqd1vp2vcznnlqmm7ifj50l";
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

  meta = with stdenv.lib; {
    description = "A style to bend Qt applications to look like they belong into GNOME Shell";
    homepage = https://github.com/FedoraQt/adwaita-qt;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ worldofpeace ];
    platforms = platforms.linux;
  };
}
