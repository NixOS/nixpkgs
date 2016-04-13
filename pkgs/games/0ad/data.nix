{ stdenv, fetchurl, version, releaseType }:

stdenv.mkDerivation rec {
  name = "0ad-data-${version}";

  src = fetchurl {
    url = "http://releases.wildfiregames.com/0ad-${version}-${releaseType}-unix-data.tar.xz";
    sha256 = "0f406ynz2fbg3hwavh52xh4f7kqm4mzhz59kkvb6dpsax5agalwk";
  };

  patchPhase = ''
    rm binaries/data/tools/fontbuilder/fonts/*.txt
  '';

  installPhase = ''
    mkdir -p $out/share/0ad
    cp -r binaries/data/* $out/share/0ad/
  '';
}
