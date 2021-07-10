{ stdenv, lib, fetchFromBitbucket, p7zip, cmake
, SDL2, bzip2, zlib, libjpeg
, libsndfile, mpg123
, SDL2_net, SDL2_mixer }:

stdenv.mkDerivation rec {
  pname = "lzwolf";
  version = "20210221";

  src = fetchFromBitbucket {
    owner = "linuxwolf6";
    repo = "lzwolf";
    rev = "b68c556675a76de0817767ead97c64061a97136e";
    sha256 = "0v28zqh54ara7zpv1shn93wp2wkpgb6mjn1k0h23jrikyhn0r8cr";
  };
  nativeBuildInputs = [ p7zip cmake ];
  buildInputs = [
    SDL2 bzip2 zlib libjpeg SDL2_mixer SDL2_net libsndfile mpg123
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DGPL=ON"
  ];

  doCheck = true;

  installPhase = ''
    install -Dm755 lzwolf "$out/lib/lzwolf/lzwolf"
    for i in *.pk3; do
      install -Dm644 "$i" "$out/lib/lzwolf/$i"
    done
    mkdir -p $out/bin
    ln -s $out/lib/lzwolf/lzwolf $out/bin/lzwolf
  '';

  meta = with lib; {
    homepage = "https://bitbucket.org/linuxwolf6/lzwolf";
    description = "Enhanced fork of ECWolf, a Wolfenstein 3D source port";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ tgunnoe ];
  };
}
