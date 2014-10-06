{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "steam-1.0.0.48";

  src = fetchurl {
    url = http://repo.steampowered.com/steam/pool/steam/s/steam/steam_1.0.0.48.tar.gz;
    sha256 = "08y5qf75ssk4fnazyv2yz1c5zs7gjiwigaibv8yz1gbr290r0b52";
  };

  installPhase = ''
    make DESTDIR=$out install
    mv $out/usr/* $out #*/
    rmdir $out/usr
  '';

  meta = {
    description = "A digital distribution platform";
    homepage = http://store.steampowered.com/;
    license = stdenv.lib.licenses.unfree;
  };
}
