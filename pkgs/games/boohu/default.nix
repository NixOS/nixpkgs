{stdenv, fetchurl, buildGoPackage}:

buildGoPackage rec {

  pname = "boohu";
  version = "0.13.0";

  goPackagePath = "git.tuxfamily.org/boohu/boohu.git";

  src = fetchurl {
    url = "https://download.tuxfamily.org/boohu/downloads/${pname}-${version}.tar.gz";
    sha256 = "0q89yv4klldjpli6y9xpyr6k8nsn7qa68gp90vb3dgxynn91sh68";
  };

  goDeps = ./deps.nix;

  postInstall = "mv $out/bin/boohu.git $out/bin/boohu";

  meta = with stdenv.lib; {
    description = "A new coffee-break roguelike game";
    longDescription = ''
      Break Out Of Hareka's Underground (Boohu) is a roguelike game mainly
      inspired from DCSS and its tavern, with some ideas from Brogue, but
      aiming for very short games, almost no character building, and a
      simplified inventory.
    '';
    homepage = "https://download.tuxfamily.org/boohu/index.html";
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = with maintainers; [freepotion];
  };
}
