{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, installShellFiles
}:

let
  version = "6.24";
  downloadVersion = lib.replaceStrings [ "." ] [ "" ] version;
  # Use `./update.sh` to generate the entries below
  srcs = {
    i686-linux = {
      url = "https://www.rarlab.com/rar/rarlinux-x32-${downloadVersion}.tar.gz";
      hash = "sha256-aacgJH0iJLRNEaZuVyzl/FxZgSnW3dIZFUfaqt0l88M=";
    };
    x86_64-linux = {
      url = "https://www.rarlab.com/rar/rarlinux-x64-${downloadVersion}.tar.gz";
      hash = "sha256-iOIqjoQSXJR2N7vyjHRuM4oKYyedgPn51zc2A4ddses=";
    };
    aarch64-darwin = {
      url = "https://www.rarlab.com/rar/rarmacos-arm-${downloadVersion}.tar.gz";
      hash = "sha256-2r4zWDT7Xw/CNvA7oNEsGfrXJDzFa5gNthIB/5TYR5U=";
    };
    x86_64-darwin = {
      url = "https://www.rarlab.com/rar/rarmacos-x64-${downloadVersion}.tar.gz";
      hash = "sha256-4vENPNfMpQstsm9+8+glHPK9fAlDmnHWbCHW+HUwSX4=";
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

  src = fetchurl (srcs.${stdenv.hostPlatform.system});

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
