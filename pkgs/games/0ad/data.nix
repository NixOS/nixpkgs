{ lib, stdenv, fetchurl, zeroad-unwrapped }:

stdenv.mkDerivation rec {
  pname = "0ad-data";
  inherit (zeroad-unwrapped) version;

  src = fetchurl {
    url = "http://releases.wildfiregames.com/0ad-${version}-alpha-unix-data.tar.xz";
    sha256 = "0b53jzl64i49rk3n3c3x0hibwbl7vih2xym8jq5s56klg61qdxa1";
  };

  installPhase = ''
    rm binaries/data/tools/fontbuilder/fonts/*.txt
    mkdir -p $out/share/0ad
    cp -r binaries/data $out/share/0ad/
  '';

  meta = with lib; {
    description = "A free, open-source game of ancient warfare -- data files";
    homepage = "https://play0ad.com/";
    license = licenses.cc-by-sa-30;
    maintainers = with maintainers; [ chvp ];
    platforms = platforms.linux;
    hydraPlatforms = [];
  };
}
