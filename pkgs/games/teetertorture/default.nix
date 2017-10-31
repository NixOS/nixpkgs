{stdenv, fetchurl, SDL, SDL_image, SDL_mixer}:

stdenv.mkDerivation {
  name = "teeter-torture-20051018";
  src = fetchurl {
    url = ftp://ftp.tuxpaint.org/unix/x/teetertorture/source/teetertorture-2005-10-18.tar.gz;
    sha256 = "175gdbkx3m82icyzvwpyzs4v2fd69c695k5n8ca0lnjv81wnw2hr";
  };

  buildInputs = [ SDL SDL_image SDL_mixer];

  configurePhase = ''
    sed -i s,data/,$out/share/teetertorture/, src/teetertorture.c
  '';

  patchPhase = ''
    sed -i '/free(home)/d' src/teetertorture.c
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/teetertorture
    cp teetertorture $out/bin
    cp -R data/* $out/share/teetertorture
  '';

  meta = {
    homepage = http://www.newbreedsoftware.com/teetertorture/;
    description = "Simple shooting game with your cannon is sitting atop a teeter totter";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
