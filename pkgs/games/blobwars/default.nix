{ stdenv, lib, fetchurl, pkg-config, gettext, SDL2, SDL2_image, SDL2_mixer, SDL2_net, SDL2_ttf, zlib }:

stdenv.mkDerivation rec {
  pname = "blobwars";
  version = "2.00";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    sha256 = "c406279f6cdf2aed3c6edb8d8be16efeda0217494acd525f39ee2bd3e77e4a99";
  };

  patches = [ ./blobwars-2.00-glibc-2.38.patch ];

  nativeBuildInputs = [ pkg-config gettext ];
  buildInputs = [ SDL2 SDL2_image SDL2_mixer SDL2_net SDL2_ttf zlib ];
  env.NIX_CFLAGS_COMPILE = toString [ "-Wno-error" ];

  makeFlags = [ "PREFIX=$(out)" "RELEASE=1" ];

  postInstall = ''
    install -Dm755 $out/games/blobwars -t $out/bin
    rm -r $out/games
    cp -r {data,gfx,sound,music} $out/share/games/blobwars/
    # fix world readable bit
    find $out/share/games/blobwars/. -type d -exec chmod 755 {} +
    find $out/share/games/blobwars/. -type f -exec chmod 644 {} +
  '';

  meta = with lib; {
    description = "Platform action game featuring a blob with lots of weapons";
    homepage = "https://www.parallelrealities.co.uk/games/metalBlobSolid/";
    license = with licenses; [ gpl2Plus free ];
    maintainers = with maintainers; [ iblech ];
    platforms = platforms.unix;
  };
}
