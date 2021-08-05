{ stdenv
, fetchFromGitHub
, cmake
, pkg-config
, qttools
, qtx11extras
, ffmpeg
, wrapQtAppsHook
, copyDesktopItems
, android-tools
, makeDesktopItem
, lib
}:

stdenv.mkDerivation rec {
  pname = "qtscrcpy";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "barry-ran";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2d7AIUra7Uc/N0Ako8JYo07GUTPNgorxl2hmeDJOGPU=";
  };

  nativeBuildInputs = [ cmake pkg-config wrapQtAppsHook copyDesktopItems ];
  buildInputs = [ qttools qtx11extras ffmpeg ];

  postPatch = ''
    substituteInPlace ./QtScrcpy/main.cpp \
      --replace "../../../third_party/adb/linux/adb" "${android-tools.out}/bin/adb" \
      --replace "../../../third_party/scrcpy-server" "$out/scrcpy-server"
  '';

  installPhase = ''
    mkdir -p $out/bin/
    cp ../output/linux/release/QtScrcpy $out/bin/
    cp ${src}/third_party/scrcpy-server $out/
    mkdir -p $out/share/pixmaps/
    cp ${src}/backup/logo.png $out/share/pixmaps/${pname}.png
    runHook postInstall
  '';

  # https://aur.archlinux.org/cgit/aur.git/tree/qtscrcpy.desktop?h=qtscrcpy
  desktopItems = [
    (makeDesktopItem {
      name = pname;
      type = "Application";
      icon = pname;
      desktopName = "QtScrcpy";
      exec = "QtScrcpy";
      terminal = false;
      categories = "Development;Utility";
      comment = "Android real-time screencast control tool";
    })
  ];

  meta = with lib; {
    description = "Android real-time display control software";
    homepage = "https://github.com/barry-ran/QtScrcpy";
    license = licenses.asl20;
    maintainers = [ maintainers.vanilla ];
    platforms = platforms.linux;
  };
}
