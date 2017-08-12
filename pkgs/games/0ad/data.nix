{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "0ad-data-${version}";
  version = "0.0.22";

  src = fetchurl {
    url = "http://releases.wildfiregames.com/0ad-${version}-alpha-unix-data.tar.xz";
    sha256 = "0vknk9ay9h2p34r7mym2g066f3s3c5d5vmap0ckcs5b86h5cscjc";
  };

  installPhase = ''
    rm binaries/data/tools/fontbuilder/fonts/*.txt
    mkdir -p $out/share/0ad
    cp -r binaries/data $out/share/0ad/
  '';

  meta = with stdenv.lib; {
    description = "A free, open-source game of ancient warfare -- data files";
    homepage = http://wildfiregames.com/0ad/;
    license = licenses.cc-by-sa-30;
    platforms = platforms.linux;
    hydraPlatforms = [];
  };
}
