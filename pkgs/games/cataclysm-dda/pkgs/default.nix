{
  lib,
  newScope,
  build ? null,
}:
lib.makeScope newScope (
  self:
  let
    inherit (self) callPackage;
  in
  {
    mod = { };

    soundpack = { };

    tileset = {
      UndeadPeople = callPackage ./tilesets/UndeadPeople { };
    };
  }
)
