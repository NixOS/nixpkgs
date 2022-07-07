{ lib, stdenv, fetchurl, autoPatchelfHook, installShellFiles }:

let
  version = "6.11";
  downloadVersion = lib.replaceStrings [ "." ] [ "" ] version;
  srcUrl = {
    i686-linux = {
      url = "https://www.rarlab.com/rar/rarlinux-x32-${downloadVersion}.tar.gz";
      sha256 = "sha256-7mpKkOEspGskt9yfSDrdK7CieJ0AectJKTi8TxLnbtk=";
    };
    x86_64-linux = {
      url = "https://www.rarlab.com/rar/rarlinux-x64-${downloadVersion}.tar.gz";
      sha256 = "sha256-pb3QdLqdxIf3ybLfPao3MdilTHYjCB1BujYsTQuEMtE=";
    };
    aarch64-darwin = {
      url = "https://www.rarlab.com/rar/rarmacos-arm-${downloadVersion}.tar.gz";
      sha256 = "sha256-q2fC4w2/tJ+GaD3ETPP+V3SAApdlLDgr3eE2YcERQXA=";
    };
    x86_64-darwin = {
      url = "https://www.rarlab.com/rar/rarmacos-x64-${downloadVersion}.tar.gz";
      sha256 = "sha256-yHWxAscqnLKrG9Clsaiy6wSbyVz4gpvN6AjyirCmIKQ=";
    };
  }.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");
  manSrc = fetchurl {
    url = "https://aur.archlinux.org/cgit/aur.git/plain/rar.1?h=rar&id=8e39a12e88d8a3b168c496c44c18d443c876dd10";
    name = "rar.1";
    sha256 = "sha256-93cSr9oAsi+xHUtMsUvICyHJe66vAImS2tLie7nt8Uw=";
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
