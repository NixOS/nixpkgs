{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, installShellFiles
}:

let
  version = "7.00";
  downloadVersion = lib.replaceStrings [ "." ] [ "" ] version;
  # Use `./update.sh` to generate the entries below
  srcs = {
    i686-linux = {
      url = "https://www.rarlab.com/rar/rarlinux-x32-${downloadVersion}.tar.gz";
      hash = "sha256-5y2BaclEKLUpZayqzilaLPcYi0dZkKpn99n5E+Z5lOo=";
    };
    x86_64-linux = {
      url = "https://www.rarlab.com/rar/rarlinux-x64-${downloadVersion}.tar.gz";
      hash = "sha256-Hbv68alpeCbuHFLP36EGZ/9nE1ANlpJjg6h3Gz7u4iI=";
    };
    aarch64-darwin = {
      url = "https://www.rarlab.com/rar/rarmacos-arm-${downloadVersion}.tar.gz";
      hash = "sha256-icfpbU/UkysY4Z2wHDMWy1FnuqYkDJeDkF8yUrZuMUM=";
    };
    x86_64-darwin = {
      url = "https://www.rarlab.com/rar/rarmacos-x64-${downloadVersion}.tar.gz";
      hash = "sha256-/ImdlFyCCKU1/1XluAxCz11lge7+EoIE1zjBL9c2IQc=";
    };
  };
  manSrc = fetchurl {
    url = "https://aur.archlinux.org/cgit/aur.git/plain/rar.1?h=rar&id=8e39a12e88d8a3b168c496c44c18d443c876dd10";
    name = "rar.1";
    hash = "sha256-93cSr9oAsi+xHUtMsUvICyHJe66vAImS2tLie7nt8Uw=";
  };
in
stdenv.mkDerivation {
  pname = "rar";
  inherit version;

  src = fetchurl (srcs.${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}"));

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

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Utility for RAR archives";
    homepage = "https://www.rarlab.com/";
    license = licenses.unfree;
    mainProgram = "rar";
    maintainers = with maintainers; [ thiagokokada ];
    platforms = lib.attrNames srcs;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
