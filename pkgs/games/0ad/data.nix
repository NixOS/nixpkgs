{
  lib,
  stdenv,
  fetchurl,
  zeroad-unwrapped,
}:

stdenv.mkDerivation rec {
  pname = "0ad-data";
  inherit (zeroad-unwrapped) version;

  src = fetchurl {
    url = "http://releases.wildfiregames.com/0ad-${version}-alpha-unix-data.tar.xz";
    sha256 = "sgDkhVj4goB5EOPGhlZ7ajliSNnUGAROz94JCwV3LX0=";
  };

  installPhase = ''
    rm binaries/data/tools/fontbuilder/fonts/*.txt
    mkdir -p $out/share/0ad
    cp -r binaries/data $out/share/0ad/
  '';

  meta = {
    description = "Free, open-source game of ancient warfare -- data files";
    homepage = "https://play0ad.com/";
    license = lib.licenses.cc-by-sa-30;
    maintainers = with lib.maintainers; [ chvp ];
    platforms = lib.platforms.linux;
    hydraPlatforms = [ ];
  };
}
