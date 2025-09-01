{
  lib,
  buildTileSet,
  fetchFromGitHub,
}:

buildTileSet {
  modName = "UndeadPeople";
  version = "2020-07-08";

  src = fetchFromGitHub {
    owner = "jmz-b";
    repo = "UndeadPeopleTileset";
    rev = "f7f13b850fafe2261deee051f45d9c611a661534";
    sha256 = "0r06srjr7rq51jk9yfyxz80nfgb98mkn86cbcjfxpibgbqvcp0zm";
  };

  modRoot = "MSX++UnDeadPeopleEdition";

  meta = with lib; {
    description = "Cataclysm DDA tileset based on MSX++ tileset";
    homepage = "https://github.com/jmz-b/UndeadPeopleTileset";
    license = licenses.unfree;
    maintainers = with maintainers; [ mnacamura ];
    platforms = platforms.all;
  };
}
