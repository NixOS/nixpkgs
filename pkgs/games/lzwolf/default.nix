{ stdenv, lib, fetchFromBitbucket, p7zip, cmake
, SDL2, bzip2, zlib, libjpeg
, libsndfile, mpg123
, SDL2_net, SDL2_mixer }:

stdenv.mkDerivation rec {
  pname = "lzwolf";
  version = "unstable-2022-01-04";

  src = fetchFromBitbucket {
    owner = "linuxwolf6";
    repo = "lzwolf";
    rev = "6e470316382b87378966f441e233760ce0ff478c";
    sha256 = "sha256-IbZleY2FPyW3ORIGO2YFXQyAf1l9nDthpJjEKTTsilM=";
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
