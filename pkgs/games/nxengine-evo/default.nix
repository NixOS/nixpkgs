{ lib, stdenv
, fetchpatch
, fetchurl
, cmake
, libpng
, SDL2
, SDL2_mixer
}:

stdenv.mkDerivation rec {
  pname = "nxengine-evo";
  version = "2.6.4";
  src = fetchurl {
    url = "https://github.com/nxengine/nxengine-evo/archive/v${version}.tar.gz";
    sha256 = "1xir74l0vrzrpyl7sfqfxp083dakbix26hd0arwf2y57w1mbjas8";
  };
  assets = fetchurl {
    url = "https://github.com/nxengine/nxengine-evo/releases/download/v${version}/NXEngine-v${version}-Linux.tar.xz";
    sha256 = "1b5hkmsrrhnjjf825ri6n62kb3fldwl7v5f1cqvqyv47zv15g5gy";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/nxengine/nxengine-evo/commit/1890127ec4b4b5f8d6cb0fb30a41868e95659840.patch";
      sha256 = "18j22vzkikcwqd42vlhzd6rjp26dq0zslxw5yyl07flivms0hny2";
    })
    (fetchpatch {
      url = "https://github.com/nxengine/nxengine-evo/commit/75b8b8e3b067fd354baa903332f2a3254d1cc017.patch";
      sha256 = "0sjr7z63gp7nfxifxisvp2w664mxxk3xi4a3d86mm0470dj5m5bx";
    })
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    libpng
    SDL2
    SDL2_mixer
  ];

  # Allow finding game assets.
  postPatch = ''
    sed -i -e "s,/usr/share/,$out/share/," src/ResourceManager.cpp
  '';

  installPhase = ''
    cd ..
    unpackFile ${assets}
    mkdir -p $out/bin/ $out/share/nxengine/
    install bin/* $out/bin/
    cp -r NXEngine-evo-${version}-Linux/data/ $out/share/nxengine/data
    chmod -R a=r,a+X $out/share/nxengine/data
  '';

  meta = {
    description = "A complete open-source clone/rewrite of the masterpiece jump-and-run platformer Doukutsu Monogatari (also known as Cave Story)";
    license = with lib.licenses; [
      gpl3                   # Game engine
      unfreeRedistributable  # Game assets, freeware
    ];
    maintainers = [ lib.maintainers.scubed2 ];
    homepage = "https://github.com/nxengine/nxengine-evo";
    platforms = lib.platforms.linux;
  };
}
