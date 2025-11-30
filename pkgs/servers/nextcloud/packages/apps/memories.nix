{
  stdenv,
  buildGoModule,
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
    "31" = {
      version = "7.7.0";
      appHash = "sha256-ORv+6XkN+qTk5bXMFKv2Mv/jU+7F12IbWE9JjV2ot9o=";
      srcHash = "sha256-hiYAQshi84oOw1qfNECWAssbln8UPwD+8Hfb2pKw8no=";
    };
    "32" = latestVersionForNc."31";
  };
  currentVersionInfo =
    latestVersionForNc.${ncVersion}
      or (throw "memories currently does not support nextcloud version ${ncVersion}");

  commonMeta = with lib; {
    homepage = "https://apps.nextcloud.com/apps/memories";
    changelog = "https://github.com/pulsejet/memories/blob/v${currentVersionInfo.version}/CHANGELOG.md";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };

  go-vod = buildGoModule rec {
    pname = "go-vod";
    inherit (currentVersionInfo) version;

    src = fetchFromGitHub {
      owner = "pulsejet";
      repo = "memories";
      tag = "v${version}";
      hash = currentVersionInfo.srcHash;
    };

    sourceRoot = "${src.name}/go-vod";

    vendorHash = null;

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
