{lib, fetchurl, buildGoModule}:

buildGoModule rec {
  pname = "harmonist";
  version = "0.5.1";

  src = fetchurl {
    url = "https://download.tuxfamily.org/harmonist/releases/${pname}-${version}.tar.gz";
    hash = "sha256-NkUrBvOOs6yctW4CVRpJNcdfdPvUJZp9HaWLS7eO4yE=";
  };

  vendorHash = "sha256-0DV32a2LYnfYzg/tqwear9uaaahNUIi0M8uWlXOQ5Ic=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Stealth coffee-break roguelike game";
    mainProgram = "harmonist";
    longDescription = ''
      Harmonist is a stealth coffee-break roguelike game. The game has a heavy
      focus on tactical positioning, light and noise mechanisms, making use of
      various terrain types and cones of view for monsters. Aiming for a
      replayable streamlined experience, the game avoids complex inventory
      management and character building, relying on items and player
      adaptability for character progression.
    '';
    homepage = "https://harmonist.tuxfamily.org/";
    license = licenses.isc;
    maintainers = with maintainers; [ ];
  };
}
