{ lib, stdenv, fetchurl, gzip }:

let
  inherit (stdenv.hostPlatform) system;

  throwSystem = throw "Unsupported system: ${stdenv.hostPlatform.system}";

  sha256 = {
    "x86_64-linux" = "sha256-F3Gn2b5zhgd+galkJIt5Hw2fDs9SGKPE7vxi+GRR3h0=";
    "i686-linux" = "sha256-+wRLqFJIVf6lAkfK7war3xXdIFxbGLP5BnbE9yylrzM=";
    "aarch64-linux" = "sha256-w4ZRrHFejXGUgQQ/N46AqVe/8+Bo5y1zRkA9p1OMQF0=";
    "x86_64-darwin" = "sha256-2zQ1oeqo5w6lZYVkOcKph9Z9spfvgiImOUjlGYR3p6s=";
    "aarch64-darwin" = "sha256-Jc7vxdsN29gSzNtdlD6R1LnQh/5MF4fYkIL7PS4La0o=";
  }."${system}" or throwSystem;

  platform = {
    "x86_64-linux" = "linux-amd64";
    "i686-linux" = "linux-386";
    "aarch64-linux" = "linux-armv8";
    "x86_64-darwin" = "darwin-amd64";
    "aarch64-darwin" = "darwin-arm64";
  }."${system}" or throwSystem;

in
stdenv.mkDerivation rec {
  pname = "clash-premium";
  version = "2022.08.26";

  src = fetchurl {
    url = "https://github.com/Dreamacro/clash/releases/download/premium/clash-${platform}-${version}.gz";
    inherit sha256;
  };

  unpackPhase = ''
    ${gzip}/bin/gzip -dc $src > clash
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 clash $out/bin/clash

    runHook postInstall
  '';

  meta = with lib; {
    description = "Close-sourced pre-built Clash binary with TUN support";
    homepage = "https://github.com/Dreamacro/clash/releases/tag/premium/";
    license = licenses.unfree;
    maintainers = with maintainers; [ candyc1oud ];
    platforms = [ "i686-linux" "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
}
