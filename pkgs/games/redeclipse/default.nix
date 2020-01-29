{ stdenv, fetchFromGitHub, fetchurl, fetchpatch
, curl, ed, pkgconfig, zlib, libX11
, SDL2, SDL2_image, SDL2_mixer
}:

stdenv.mkDerivation rec {
  pname = "redeclipse";
  version = "1.6.0";

  src = fetchurl {
    url = "https://github.com/redeclipse/base/releases/download/v${version}/redeclipse_${version}_nix.tar.bz2";
    sha256 = "0j98zk7nivdsap4y50dlqnql17hdila1ikvps6vicwaqb3l4gaa8";
  };

  buildInputs = [
    libX11 zlib
    SDL2 SDL2_image SDL2_mixer
  ];

  nativeBuildInputs = [
    curl ed pkgconfig
  ];

  makeFlags = [ "-C" "src/" "prefix=$(out)" ];

  patches = [
    # "remove gamma name hack" - Can't find `____gammaf128_r_finite` otherwise
    # Is likely to be included in next release
    (fetchpatch {
       url = "https://github.com/red-eclipse/base/commit/b16b4963c1ad81bb9ef784bc4913a4c8ab5f1bb4.diff";
       sha256 = "1bm07qrq60bbmbf5k9255qq115mcyfphfy2f7xl1yx40mb9ns65p";
    })
  ];

  enableParallelBuilding = true;

  installTargets = [ "system-install" ];

  postInstall = ''
      cp -R -t $out/share/redeclipse/data/ data/*
  '';

  meta = with stdenv.lib; {
    description = "A first person arena shooter, featuring parkour, impulse boosts, and more.";
    longDescription = ''
      Red Eclipse is a fun-filled new take on the first person arena shooter,
      featuring parkour, impulse boosts, and more. The development is geared
      toward balanced gameplay, with a general theme of agility in a variety of
      environments.
    '';
    homepage = "https://www.redeclipse.net";
    license = with licenses; [ licenses.zlib cc-by-sa-30 ];
    maintainers = with maintainers; [ lambda-11235 ];
    platforms = platforms.linux;
    hydraPlatforms = [];
  };
}
