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
    _d_ae_ver              = "0.0.3228";
    _d_btrfs_ver           = "0.0.13";
    _d_ncurses_ver         = "0.0.149";
    _d_emsi_containers_ver = "0.9.0";
in
stdenv.mkDerivation rec {
    pname = "btdu";
    version = "0.5.0";

    srcs = [
      (fetchurl {
        url = "https://github.com/CyberShadow/${pname}/archive/v${version}.tar.gz";
        sha256 = "90ba4d8997575993e9d39a503779fb32b37bb62b8d9386776e95743bfc859606";
      })
      (fetchurl {
        url = "https://github.com/CyberShadow/ae/archive/v${_d_ae_ver}.tar.gz";
        sha256 = "6b3da61d9f7f1a7343dbe5691a16482cabcd78532b7c09ed9d63eb1934f1b9d8";
      })
      (fetchurl {
        url = "https://github.com/CyberShadow/d-btrfs/archive/v${_d_btrfs_ver}.tar.gz";
        sha256 = "05a59cd64000ce2af9bd0578ef5118ab4d10de0ec50410ba0d4e463f01cfaa4e";
      })
      (fetchurl {
        url = "https://github.com/D-Programming-Deimos/ncurses/archive/v${_d_ncurses_ver}.tar.gz";
        sha256 = "2c8497f5dd93f9d3a05ca7ed57c4fcaee1e988fd25a24de106917ddf72f34646";
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
    };
}
