{ lib, buildTileSet, fetchFromGitHub }:

buildTileSet {
  modName = "UndeadPeople";
  version = "2020-04-07";

  src = fetchFromGitHub {
    owner = "SomeDeadGuy";
    repo = "UndeadPeopleTileset";
    rev = "6686230b35b712612b3c7573349740b6f7968ff9";
    sha256 = "02higdazd7v2gci5lr8r7fhc6yr2az6gbvksgz0lrgh1wg8xgqgs";
  };

  modRoot = "MSX++UnDeadPeopleEdition";

  meta = with lib; {
    description = "Cataclysm DDA tileset based on MSX++ tileset";
    homepage = "https://github.com/SomeDeadGuy/UndeadPeopleTileset";
    license = licenses.unfree;
    maintainers = with maintainers; [ mnacamura ];
    platforms = platforms.all;
  };
}
