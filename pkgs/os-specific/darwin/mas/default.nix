{ lib
, stdenv
, fetchurl
, libarchive
, p7zip
}:

stdenv.mkDerivation rec {
  pname = "mas";
  version = "1.8.2";

  src = fetchurl {
    url = "https://github.com/mas-cli/mas/releases/download/v${version}/mas.pkg";
    sha256 = "HlLQKBVIYKanS6kjkbYdabBi1T0irxE6fNd2H6mDKe4=";
  };

  nativeBuildInputs = [ libarchive p7zip ];

  unpackPhase = ''
    7z x $src
    bsdtar -xf Payload~
  '';

  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    cp -r ./usr/local/bin $out
  '';

  meta = with lib; {
    description = "Mac App Store command line interface";
    homepage = "https://github.com/mas-cli/mas";
    license = licenses.mit;
    maintainers = with maintainers; [ zachcoyle ];
    platforms = platforms.darwin;
  };
}
