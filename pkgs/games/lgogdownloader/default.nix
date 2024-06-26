{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, curl
, boost
, liboauth
, jsoncpp
, htmlcxx
, rhash
, tinyxml-2
, help2man
, html-tidy
, wrapQtAppsHook
, qtbase
, qtwebengine
, testers
, lgogdownloader

, enableGui ? true
}:

stdenv.mkDerivation rec {
  pname = "lgogdownloader";
  version = "3.14";

  src = fetchFromGitHub {
    owner = "Sude-";
    repo = "lgogdownloader";
    rev = "refs/tags/v${version}";
    hash = "sha256-pxYiSefscglHN53wvp38Ec4/3X46sWc56Y4YKNtqABQ=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    help2man
    html-tidy
  ] ++ lib.optional enableGui wrapQtAppsHook;

  buildInputs = [
    boost
    curl
    htmlcxx
    jsoncpp
    liboauth
    rhash
    tinyxml-2
  ] ++ lib.optionals enableGui [
    qtbase
    qtwebengine
  ];

  cmakeFlags = lib.optional enableGui "-DUSE_QT_GUI=ON";

  passthru.tests = {
    version = testers.testVersion { package = lgogdownloader; };
  };

  meta = with lib; {
    description = "Unofficial downloader to GOG.com for Linux users. It uses the same API as the official GOGDownloader";
    mainProgram = "lgogdownloader";
    homepage = "https://github.com/Sude-/lgogdownloader";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ _0x4A6F ];
    platforms = platforms.linux;
  };
}
