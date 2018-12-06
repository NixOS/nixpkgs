{stdenv, fetchurl, buildGoPackage}:

buildGoPackage rec {

  name = "boohu-${version}";
  version = "0.11.1";

  goPackagePath = "git.tuxfamily.org/boohu/boohu.git";

  src = fetchurl {
    url = "https://download.tuxfamily.org/boohu/downloads/boohu-${version}.tar.gz";
    sha256 = "0m0ajxiyx8qwxj2zq33s5qpjr65cr33f7dpirg6b4w4y9gyhhv1g";
  };

  buildFlags = "--tags ansi";

  postInstall = "mv $bin/bin/boohu.git $bin/bin/boohu";

  meta = with stdenv.lib; {
    description = "A new roguelike game";
    longDescription = ''
      Break Out Of Hareka's Underground (Boohu) is a roguelike game mainly
      inspired from DCSS and its tavern, with some ideas from Brogue, but
      aiming for very short games, almost no character building, and a
      simplified inventory.
    '';
    homepage = https://download.tuxfamily.org/boohu/index.html;
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = with maintainers; [freepotion];
  };
}
