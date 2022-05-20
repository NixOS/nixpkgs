{ pkgs, lib, stdenv
, fetchurl
, autoPatchelfHook
, openssl
, ffmpeg
, sqlite
, makeWrapper
}:

let
  version = "0.15.0";

  platforms = {
    aarch64-darwin = {
      name = "macos-applesilicon";
      sha256 = "sha256-m2GzcfuhixCTur89HsAfpY0hT4C4j7nvdsOK5zjVPqQ=";
    };
    aarch64-linux = {
      name = "linux-arm64v8";
      sha256 = "sha256-P7HB5i0DAoNDFvBhrkvr8yrKvEEUX22WTstAlxmhcC8=";
    };
    armv6l-linux = {
      name = "linux-arm32v6";
      sha256 = "sha256-P/tj+P5m3xTZlEohe0VdWsJwuarpkNF00Z+bQHSRBHY=";
    };
    armv7l-linux = {
      name = "linux-arm32v7";
      sha256 = "sha256-B6ocSKrSJEcY+lTpaweTWyZ/uZhavlUv4DkZ0mq4gQU=";
    };
    x86_64-darwin = {
      name = "macos-intel";
      sha256 = "sha256-/T1GkQT/FB/+5nQahIfOi9S0ycO50buMqLwNyJm3uK0=";
    };
    x86_64-linux = {
      name = "linux";
      sha256 = "sha256-QC1/OJAjMqNAV20nmL+DfPlsbtjLib5XKiugdknGAHM=";
    };
  };

  plat = if (lib.hasAttrByPath [ stdenv.hostPlatform.system ] platforms)
    then platforms.${stdenv.hostPlatform.system}
    else throw "Unsupported architecture: ${stdenv.hostPlatform.system}";
in stdenv.mkDerivation rec {
  inherit version;

  name = "stash-${version}";

  executable = fetchurl {
    inherit (plat) sha256;
    url = "https://github.com/stashapp/stash/releases/download/v${version}/stash-${plat.name}";
    executable = true;
  };

  dontUnpack = true;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    ffmpeg
    openssl
    sqlite
    makeWrapper
    (pkgs.python3.withPackages (p: with p; [ requests configparser progressbar cloudscraper ]))
  ];

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper "${executable}" "$out/bin/stash" \
      --prefix PATH ":" "${lib.makeBinPath [ ffmpeg ]}"
  '';

  meta = with lib; {
    description = "Private video and image server";
    license = licenses.gpl3;
    homepage = "https://stashapp.cc";
    maintainers = with lib.maintainers; [ nocoolnametom ];
  };
}
