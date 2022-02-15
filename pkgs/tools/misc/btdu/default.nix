{stdenv, lib, fetchurl, dub, ncurses, ldc, zlib, removeReferencesTo }:

let
    _d_ae_ver              = "0.0.3100";
    _d_btrfs_ver           = "0.0.12";
    _d_ncurses_ver         = "0.0.149";
    _d_emsi_containers_ver = "0.9.0";
in
stdenv.mkDerivation rec {
    pname = "btdu";
    version = "0.3.1";

    srcs = [
      (fetchurl {
        url = "https://github.com/CyberShadow/${pname}/archive/v${version}.tar.gz";
        sha256 = "760b2f0d28920a78b7967dd34c429125135688a3aefc57ab3a92d07bc3ef10cb";
      })
      (fetchurl {
        url = "https://github.com/CyberShadow/ae/archive/v${_d_ae_ver}.tar.gz";
        sha256 = "86fa09ef6c1be4cbe8ad1c85729054e5d691b41ff57c7980d99937ec0f45b950";
      })
      (fetchurl {
        url = "https://github.com/CyberShadow/d-btrfs/archive/v${_d_btrfs_ver}.tar.gz";
        sha256 = "cf2b1fa3e94a0aa239d465adbac239514838835283521d632f571948aa517f92";
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
      license = licenses.gpl2Only;
      platforms = platforms.linux;
      maintainers = with maintainers; [ atila ];
    };
}
