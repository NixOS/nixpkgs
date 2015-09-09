{ stdenv, fetchurl, version, releaseType }:

stdenv.mkDerivation rec {
  name = "0ad-data-${version}";

  src = fetchurl {
    url = "http://releases.wildfiregames.com/0ad-${version}-${releaseType}-unix-data.tar.xz";
    sha256 = "0i5cf4n9qhzbi6hvw5lxapind24qpqfq6p5lrhx8gb25p670g95i";
  };

  patchPhase = ''
    rm binaries/data/tools/fontbuilder/fonts/*.txt
  '';

  installPhase = ''
    mkdir -p $out/share/0ad
    cp -r binaries/data/* $out/share/0ad/
  '';
}
