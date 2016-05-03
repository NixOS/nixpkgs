{ stdenv, fetchurl, version, releaseType }:

stdenv.mkDerivation rec {
  name = "0ad-data-${version}";

  src = fetchurl {
    url = "http://releases.wildfiregames.com/0ad-${version}-${releaseType}-unix-data.tar.xz";
    sha256 = "1lzl8chfqbgs1n9vpn0xaqd70kpwiibfk196iblyq6qkms3v6pnv";
  };

  patchPhase = ''
    rm binaries/data/tools/fontbuilder/fonts/*.txt
  '';

  installPhase = ''
    mkdir -p $out/share/0ad
    cp -r binaries/data/* $out/share/0ad/
  '';
}
