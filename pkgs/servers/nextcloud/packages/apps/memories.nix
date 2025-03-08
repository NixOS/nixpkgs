{
  stdenv,
  buildGoModule,
  exiftool,
  fetchurl,
  ffmpeg,
  fetchFromGitHub,
  lib,

  ncVersion,
}:
let
  latestVersionForNc = {
    "31" = latestVersionForNc."29";
    "30" = latestVersionForNc."29";
    "29" = {
      version = "7.5.2";
      appHash = "sha256-BfxJDCGsiRJrZWkNJSQF3rSFm/G3zzQn7C6DCETSzw4=";
      srcHash = "sha256-imBO/64NW5MiozpufbMRcTI9WCaN8grnHlVo+fsUNlU=";
    };
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

  postPatch = ''
    ln -s ${lib.getExe go-vod} bin-ext/go-vod
    for bin in bin-ext/{go-vod-aarch64,go-vod-amd64}; do
      ln -sf go-vod $bin
    done

    for bin in bin-ext/{exiftool-aarch64-glibc,exiftool-aarch64-musl,exiftool-amd64-glibc,exiftool-amd64-musl}; do
      ln -sf exiftool/exiftool $bin
    done
    rm -rf bin-ext/exiftool/*
    ln -s ${lib.getExe exiftool} bin-ext/exiftool/exiftool
    substituteInPlace lib/Service/BinExt.php \
      --replace-fail "EXIFTOOL_VER = '12.70'" "EXIFTOOL_VER = '${exiftool.version}'"

    ln -s ${lib.getExe ffmpeg} bin-ext/ffmpeg
    ln -s ${lib.getExe' ffmpeg "ffprobe"} bin-ext/ffprobe
  '';

  installPhase = ''
    mkdir -p $out
    cp -r ./* $out/
  '';

  meta = commonMeta // {
    description = "Fast, modern and advanced photo management suite";
  };
}
