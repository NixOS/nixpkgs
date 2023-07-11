{lib, fetchurl, buildGoModule}:

buildGoModule rec {
  pname = "harmonist";
  version = "0.4.1";

  src = fetchurl {
    url = "https://download.tuxfamily.org/harmonist/releases/${pname}-${version}.tar.gz";
    hash = "sha256-mtvvdim0CNtdM+/VU2j+FE2oLpt0Tz1/tNTa9H/FS6U=";
  };

  vendorHash = "sha256-SrvJXTyLtPZ2PyhSZz/gJvuso9r7e5NbGe7EJRf2XlI=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "A stealth coffee-break roguelike game";
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
    maintainers = with maintainers; [ aaronjheng ];
  };
}
