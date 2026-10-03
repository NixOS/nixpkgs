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
    hash = "sha256-9YPLNl5vxdudZIsZZGdFaT1nAfrdO5+mDAXnk2XWBmQ=";
  };

  modRoot = "MSX++UnDeadPeopleEdition";

  meta = {
    description = "Cataclysm DDA tileset based on MSX++ tileset";
    homepage = "https://github.com/jmz-b/UndeadPeopleTileset";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ mnacamura ];
    platforms = lib.platforms.all;
  };
}
