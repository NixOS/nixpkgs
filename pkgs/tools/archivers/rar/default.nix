{ lib, stdenv, fetchurl, autoPatchelfHook, installShellFiles }:

let
  version = "6.21";
  downloadVersion = lib.replaceStrings [ "." ] [ "" ] version;
  # Use `nix store prefetch-file <url>` to generate the hashes for the other systems
  # TODO: create update script
  srcUrl = {
    i686-linux = {
      url = "https://www.rarlab.com/rar/rarlinux-x32-${downloadVersion}.tar.gz";
      hash = "sha256-mDeRmLTjF0ZLv4JoLrgI8YBFFulBSKfOPb6hrxDZIkU=";
    };
    x86_64-linux = {
      url = "https://www.rarlab.com/rar/rarlinux-x64-${downloadVersion}.tar.gz";
      hash = "sha256-3fr5aVkh/r6OfBEcZULJSZp5ydakJOLRPlgzMdlwGTM=";
    };
    aarch64-darwin = {
      url = "https://www.rarlab.com/rar/rarmacos-arm-${downloadVersion}.tar.gz";
      hash = "sha256-OR9HBlRteTzuyQ06tyXTSrFTBHFwmZ41kUfvgflogT4=";
    };
    x86_64-darwin = {
      url = "https://www.rarlab.com/rar/rarmacos-x64-${downloadVersion}.tar.gz";
      hash = "sha256-UN3gmEuIpCXwmw3/l+KdarAYLy1DxGoPAOB2bfJTGbw=";
    };
  }.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");
  manSrc = fetchurl {
    url = "https://aur.archlinux.org/cgit/aur.git/plain/rar.1?h=rar&id=8e39a12e88d8a3b168c496c44c18d443c876dd10";
    name = "rar.1";
    hash = "sha256-93cSr9oAsi+xHUtMsUvICyHJe66vAImS2tLie7nt8Uw=";
  };
in
stdenv.mkDerivation rec {
  pname = "rar";
  inherit version;

  src = fetchurl srcUrl;

  dontBuild = true;

  buildInputs = lib.optionals stdenv.isLinux [ stdenv.cc.cc.lib ];

  nativeBuildInputs = [ installShellFiles ]
    ++ lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  installPhase = ''
    runHook preInstall

    install -Dm755 {rar,unrar} -t "$out/bin"
    install -Dm755 default.sfx -t "$out/lib"
    install -Dm644 {acknow.txt,license.txt} -t "$out/share/doc/rar"
    install -Dm644 rarfiles.lst -t "$out/etc"

    runHook postInstall
  '';

  postInstall = ''
    installManPage ${manSrc}
  '';

  meta = with lib; {
    description = "Utility for RAR archives";
    homepage = "https://www.rarlab.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ thiagokokada ];
    platforms = with platforms; linux ++ darwin;
  };
}
