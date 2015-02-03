{ stdenv, fetchurl, version, releaseType }:

stdenv.mkDerivation rec {
  name = "0ad-data-${version}";

  src = fetchurl {
    url = "http://releases.wildfiregames.com/0ad-${version}-${releaseType}-unix-data.tar.xz";
    sha256 = "6bf2234ef5043b14a3bbeda013fefed73ce2e564262f5e03b0801bfe671331d0";
  };

  patchPhase = ''
    rm binaries/data/tools/fontbuilder/fonts/*.txt
  '';

  installPhase = ''
    mkdir -p $out/share/0ad
    cp -r binaries/data/* $out/share/0ad/
  '';
}
