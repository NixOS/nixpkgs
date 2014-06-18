{ stdenv, fetchurl, version, releaseType }:

stdenv.mkDerivation rec {
  name = "0ad-data-${version}";

  src = fetchurl {
    url = "http://releases.wildfiregames.com/0ad-${version}-${releaseType}-unix-data.tar.xz";
    sha256 = "0f16d41e81d7349fb16490f3abbfd38bcb3f2b89648355b2b281c5045ddafadc";
  };

  patchPhase = ''
    rm binaries/data/tools/fontbuilder/fonts/*.txt
  '';

  installPhase = ''
    mkdir -p $out/share/0ad
    cp -r binaries/data/* $out/share/0ad/
  '';
}
