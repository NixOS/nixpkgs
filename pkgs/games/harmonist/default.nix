{stdenv, fetchurl, buildGoPackage}:

buildGoPackage rec {

  pname = "harmonist";
  version = "0.3.0";

  goPackagePath = "git.tuxfamily.org/harmonist/harmonist.git";

  src = fetchurl {
    url = "https://download.tuxfamily.org/harmonist/releases/${pname}-${version}.tar.gz";
    sha256 = "16bh4zzq7szwcw19n34bslkf81fz3i0p4zqkd8gdi5ixkbm998lm";
  };

  goDeps = ./deps.nix;

  postInstall = "mv $bin/bin/harmonist.git $bin/bin/harmonist";

  meta = with stdenv.lib; {
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
    platforms = platforms.unix;
    maintainers = with maintainers; [freepotion];
  };
}
