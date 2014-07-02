{stdenv, fetchhg, fetchurl, unzip, SDL, SDL_net}:

stdenv.mkDerivation rec {
  name = "opentyrian-${version}";
  version = "0.0.955";

  src = fetchhg {
    url = "https://opentyrian.googlecode.com/hg/";
    rev = "13ef8ce47362";
    md5 = "95c8f9e7ff3d4207f1c692c7cec6c9b0";
  };

  data = fetchurl {
    url = http://sites.google.com/a/camanis.net/opentyrian/tyrian/tyrian21.zip;
    md5 = "2a3b206a6de25ed4b771af073f8ca904";
  };

  buildInputs = [SDL SDL_net unzip];

  patchPhase = "
    substituteInPlace src/file.c --replace /usr/share $out/share
  ";
  buildPhase = "make release";
  installPhase = "
    ensureDir $out/bin
    cp ./opentyrian $out/bin
    ensureDir $out/share/opentyrian/data
    unzip -j $data -d $out/share/opentyrian/data
  ";

  meta = {
    description = ''OpenTyrian is an open source port of the game "Tyrian".'';
    homepage = https://opentyrian.googlecode.com/;
    # This does not account of Tyrian data.
    # license = stdenv.lib.licenses.gpl2;
  };
}
