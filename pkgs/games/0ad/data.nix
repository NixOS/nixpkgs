{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "0ad-data-${version}";
  version = "0.0.21";

  src = fetchurl {
    url = "http://releases.wildfiregames.com/0ad-${version}-alpha-unix-data.tar.xz";
    sha256 = "15xadyrpvq27lm9p1ny7bcmmv56m16h3xadbkdx69gfkzxc3razk";
  };

  installPhase = ''
    rm binaries/data/tools/fontbuilder/fonts/*.txt
    mkdir -p $out/share/0ad
    cp -r binaries/data $out/share/0ad/
  '';

  meta = with stdenv.lib; {
    description = "A free, open-source game of ancient warfare -- data files";
    homepage = "http://wildfiregames.com/0ad/";
    license = licenses.cc-by-sa-30;
    platforms = platforms.linux;
    hydraPlatforms = [];
  };
}
