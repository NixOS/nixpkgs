{stdenv, lib, fetchurl, buildGoPackage, ansiTag ? false}:

buildGoPackage rec {

  name = if ansiTag then "boohu-ansi-${version}" else "boohu-${version}";
  version = "0.10.0";

  goPackagePath = "git.tuxfamily.org/boohu/boohu.git";

  src = fetchurl {
    url = "https://download.tuxfamily.org/boohu/downloads/boohu-${version}.tar.gz";
    sha256 = "a4d1fc488cfeecbe0a5e9be1836d680951941014f926351692a8dbed9042eba6";
  };

  goDeps = ./deps.nix;

  # If ansiTag is true, the "--tags ansi" will be passed
  buildFlags = if ansiTag then "--tags ansi" else "";

  # If ansiTag is true, binary output file name will be "boohu-ansi".
  # Otherwise it will be "boohu".
  postInstall = if ansiTag then "mv $bin/bin/boohu.git $bin/bin/boohu-ansi"
                else "mv $bin/bin/boohu.git $bin/bin/boohu";

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
