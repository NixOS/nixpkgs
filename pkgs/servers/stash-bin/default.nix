{ pkgs
, lib
, stdenv
, fetchurl
, autoPatchelfHook
, openssl
, ffmpeg
, sqlite
, makeWrapper
}:

let
  version = "0.18.0";

  platforms = {
    aarch64-darwin = {
      name = "macos-applesilicon";
      sha256 = "sha256-UehAXV6aUNTkoymDmh7qSY+uuqLhkgzjL2TPYsZrNUs=";
    };
    aarch64-linux = {
      name = "linux-arm64v8";
      sha256 = "sha256-us5TJ0fajhi81HRQ7hI8bvh/KRKcXlNoXLQRxGqpbt8=";
    };
    armv6l-linux = {
      name = "linux-arm32v6";
      sha256 = "sha256-97EQHNFAzCfBA1uI593M+eyIomU1BUgRWiXpKTEWckw=";
    };
    armv7l-linux = {
      name = "linux-arm32v7";
      sha256 = "sha256-y/yhgzids6TJ4CxqJa3OtDjbeWUB0jaXqS9skLb9oYg=";
    };
    x86_64-darwin = {
      name = "macos-intel";
      sha256 = "sha256-iR4s+aI8rwLjDtEHEgsiB3tgAxTMMEcUNcF4bwUv1yI=";
    };
    x86_64-linux = {
      name = "linux";
      sha256 = "sha256-05upB7EaqIWGFd24QQOTLxzL8OC+HAvH9P5dZyjDZ3U=";
    };
  };

  plat =
    if (lib.hasAttrByPath [ stdenv.hostPlatform.system ] platforms)
    then platforms.${stdenv.hostPlatform.system}
    else throw "Unsupported architecture: ${stdenv.hostPlatform.system}";
in
stdenv.mkDerivation rec {
  inherit version;

  name = "stash-bin";

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
    description = "An organizer for your porn, written in Go";
    license = licenses.agpl3Plus;
    homepage = "https://stashapp.cc";
    maintainers = with lib.maintainers; [ airradda ];
  };
}
