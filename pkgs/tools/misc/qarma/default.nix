{ mkDerivation
, lib
, fetchFromGitHub
, wrapQtAppsHook
, qtbase
, qmake
, qtx11extras
}:

mkDerivation rec {
  pname = "qarma";
  version = "2021-10-05";

  src = fetchFromGitHub {
    owner = "luebking";
    repo = pname;
    rev = "605ea4213406718ba869dd146875195e57488786";
    sha256 = "KFoFywFeGqNmE1y49DrXJZ1jIK5jMOCOspkkFME+DR8=";
  };

  postPatch = ''
    sed -i.bak -E "s,(target\.path \+=) /usr/bin,\1 $out/bin," qarma.pro
  '';

  buildInputs = [ qtbase qtx11extras ];
  nativeBuildInputs = [ qmake wrapQtAppsHook ];

  meta = with lib; {
    description = "CLI tool to create GUI dialogs with Qt";
    homepage = "https://github.com/luebking/qarma";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ milahu ];
  };
}
