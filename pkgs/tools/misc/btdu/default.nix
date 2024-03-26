{ lib
, stdenv
, fetchurl
, dub
, ncurses
, ldc
, zlib
, removeReferencesTo
}:

let
    _d_ae_ver              = "0.0.3236";
    _d_btrfs_ver           = "0.0.18";
    _d_ncurses_ver         = "1.0.0";
    _d_emsi_containers_ver = "0.9.0";
in
stdenv.mkDerivation rec {
    pname = "btdu";
    version = "0.5.1";

    srcs = [
      (fetchurl {
        url = "https://github.com/CyberShadow/${pname}/archive/v${version}.tar.gz";
        sha256 = "566269f365811f6db53280fc5476a7fcf34791396ee4e090c150af4280b35ba5";
      })
      (fetchurl {
        url = "https://github.com/CyberShadow/ae/archive/v${_d_ae_ver}.tar.gz";
        sha256 = "5ea3f0d9d2d13012ce6a1ee1b52d9fdff9dfb1d5cc7ee5d1b04cab1947ed4d36";
      })
      (fetchurl {
        url = "https://github.com/CyberShadow/d-btrfs/archive/v${_d_btrfs_ver}.tar.gz";
        sha256 = "32af4891d93c7898b0596eefb8297b88d3ed5c14c84a5951943b7b54c7599dbd";
      })
      (fetchurl {
        url = "https://github.com/D-Programming-Deimos/ncurses/archive/v${_d_ncurses_ver}.tar.gz";
        sha256 = "b5db677b75ebef7a1365ca4ef768f7344a2bc8d07ec223a2ada162f185d0d9c6";
      })
      (fetchurl {
        url = "https://github.com/dlang-community/containers/archive/v${_d_emsi_containers_ver}.tar.gz";
        sha256 = "5e256b84bbdbd2bd625cba0472ea27a1fde6d673d37a85fe971a20d52874acaa";
      })
    ];

    sourceRoot = ".";

    postUnpack = ''
      mv ae-${_d_ae_ver} "ae"
    '';


    nativeBuildInputs = [ dub ldc ];
    buildInputs = [ ncurses zlib ];

    configurePhase = ''
      runHook preConfigure
      mkdir home
      HOME="home" dub add-local ae ${_d_ae_ver}
      HOME="home" dub add-local d-btrfs-${_d_btrfs_ver} ${_d_btrfs_ver}
      HOME="home" dub add-local ncurses-${_d_ncurses_ver} ${_d_ncurses_ver}
      HOME="home" dub add-local containers-${_d_emsi_containers_ver} ${_d_emsi_containers_ver}
      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild
      cd ${pname}-${version}
      HOME="../home" dub --skip-registry=all build -b release
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      cp btdu $out/bin/
      runHook postInstall
    '';

    postInstall = ''
      ${removeReferencesTo}/bin/remove-references-to -t ${ldc} $out/bin/btdu
    '';

    passthru.updateScript = ./update.py;

    meta = with lib; {
      description = "Sampling disk usage profiler for btrfs";
      homepage = "https://github.com/CyberShadow/btdu";
      changelog = "https://github.com/CyberShadow/btdu/releases/tag/v${version}";
      license = licenses.gpl2Only;
      platforms = platforms.linux;
      maintainers = with maintainers; [ atila ];
      mainProgram = "btdu";
    };
}
