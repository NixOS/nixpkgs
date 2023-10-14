{ stdenv
, lib
, fetchFromBitbucket
, p7zip
, cmake
, SDL2
, bzip2
, zlib
, libjpeg
, libsndfile
, mpg123
, pkg-config
, SDL2_net
, SDL2_mixer
}:

stdenv.mkDerivation rec {
  pname = "lzwolf";
  # Fix-Me: Remember to remove SDL2_mixer pin (at top-level) on next lzwolf upgrade.
  version = "unstable-2022-12-26";

  src = fetchFromBitbucket {
    owner = "linuxwolf6";
    repo = "lzwolf";
    rev = "a24190604296e16941c601b57afe4350462fc659";
    sha256 = "sha256-CtBdvk6LXb/ll92Fxig/M4t4QNj8dNFJYd8F99b47kQ=";
  };

  postPatch = ''
    # SDL2_net-2.2.0 changed CMake component name slightly.
    substituteInPlace src/CMakeLists.txt \
      --replace 'SDL2::SDL2_net' 'SDL2_net::SDL2_net'
  '';

  nativeBuildInputs = [ p7zip pkg-config cmake ];
  buildInputs = [
    SDL2 bzip2 zlib libjpeg SDL2_mixer SDL2_net libsndfile mpg123
  ];

  cmakeFlags = [
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
