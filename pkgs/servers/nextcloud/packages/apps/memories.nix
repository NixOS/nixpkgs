{
  stdenv,
  buildGoLatestModule,
  exiftool,
  fetchurl,
  ffmpeg-headless,
  fetchFromGitHub,
  lib,
  replaceVars,

  ncVersion,
}:
let
  latestVersionForNc = {
    "32" = {
      version = "7.8.2";
      appHash = "sha256-O59G5kUkYlYxr8p/vEqs3LqLRKJZbeEgDhdY5eHfnZg=";
      srcHash = "sha256-KyUfrKHnRO3lMin0seSNFRnRRTPo12NbbvbkSpxSMQE=";
      vendorHash = null;
    };
    "33" = {
      version = "8.1.0";
      appHash = "sha256-SQ1gPdfICFqNBJM0dJOfKIJ/E1tBBcBQOjRdb/mKb04=";
      srcHash = "sha256-T0oz5d4kPX/Pm06vKGTrltUFd1pKccsz5IDjv/Vmuz0=";
      vendorHash = null;
    };
    "34" = latestVersionForNc."33";
    "35" = {
      version = "9.0.1";
      appHash = "sha256-xrGXpjBVvW4qtlrPynGh8c2ImmJ/u0itqHETZND0nzA=";
      srcHash = "sha256-OLsA8wNZ7sbnGsUGJrq/Jtae74P3wraKgwlWR0ipQCY=";
      vendorHash = "sha256-2MD8zRu2aLn2klqEgprr48rNNGvtj37JlKYHwbVioRg=";
    };
  };
  currentVersionInfo =
    latestVersionForNc.${ncVersion}
      or (throw "memories currently does not support nextcloud version ${ncVersion}");

  commonMeta = {
    homepage = "https://apps.nextcloud.com/apps/memories";
    changelog = "https://github.com/pulsejet/memories/blob/v${currentVersionInfo.version}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };

  go-vod = buildGoLatestModule rec {
    pname = "go-vod";
    inherit (currentVersionInfo) version vendorHash;

    src = fetchFromGitHub {
      owner = "pulsejet";
      repo = "memories";
      tag = "v${version}";
      hash = currentVersionInfo.srcHash;
    };

    sourceRoot = "${src.name}/go-vod";

    nativeCheckInputs = [ ffmpeg-headless ];

    meta = commonMeta // {
      description = "Extremely minimal on-demand video transcoding server in go";
      mainProgram = "go-vod";
    };
  };
in
stdenv.mkDerivation rec {
  pname = "nextcloud-app-memories";
  inherit (currentVersionInfo) version;

  src = fetchurl {
    url = "https://github.com/pulsejet/memories/releases/download/v${version}/memories.tar.gz";
    hash = currentVersionInfo.appHash;
  };

  patches = [
    (replaceVars ./memories-paths.diff {
      exiftool = lib.getExe exiftool;
      ffmpeg = lib.getExe ffmpeg-headless;
      ffprobe = lib.getExe' ffmpeg-headless "ffprobe";
      go-vod = lib.getExe go-vod;
    })
  ];

  postPatch = ''
    rm appinfo/signature.json
    rm -rf bin-ext/

    sed -i 's/EXIFTOOL_VER = .*/EXIFTOOL_VER = @;/' lib/Service/BinExt.php
    substituteInPlace lib/Service/BinExt.php \
      --replace-fail "EXIFTOOL_VER = @" "EXIFTOOL_VER = '${exiftool.version}'"
  '';

  installPhase = ''
    mkdir -p $out
    cp -r ./* $out/
  '';

  meta = commonMeta // {
    description = "Fast, modern and advanced photo management suite";
    longDescription = ''
      All settings related to required packages and installed programs are hardcoded in program code and cannot be changed.
    '';
  };
}
