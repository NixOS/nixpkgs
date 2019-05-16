{ stdenv, fetchurl, zeroad-unwrapped }:

stdenv.mkDerivation rec {
  name = "0ad-data-${version}";
  inherit (zeroad-unwrapped) version;

  src = fetchurl {
    url = "http://releases.wildfiregames.com/0ad-${version}-alpha-unix-data.tar.xz";
    sha256 = "04x7729hk6zw1xj3n4s4lvaviijsnbjf5rhzvjxlr5fygvg4l6z1";
  };

  installPhase = ''
    rm binaries/data/tools/fontbuilder/fonts/*.txt
    mkdir -p $out/share/0ad
    cp -r binaries/data $out/share/0ad/
  '';

  meta = with stdenv.lib; {
    description = "A free, open-source game of ancient warfare -- data files";
    homepage = "https://play0ad.com/";
    license = licenses.cc-by-sa-30;
    platforms = platforms.linux;
    hydraPlatforms = [];
  };
}
