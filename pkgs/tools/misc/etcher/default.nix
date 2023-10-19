{ lib
, stdenv
, fetchurl
, bash
, util-linux
, autoPatchelfHook
, dpkg
, makeWrapper
, udev
, electron
}:

stdenv.mkDerivation rec {
  pname = "etcher";
  version = "1.18.12";

  src = fetchurl {
    url = "https://github.com/balena-io/etcher/releases/download/v${version}/balena-etcher_${version}_amd64.deb";
    hash = "sha256-Ucs187xTpbRJ7P32hCl8cHPxO3HCs44ZneAas043FXk=";
  };

  # sudo-prompt has hardcoded binary paths on Linux and we patch them here
  # along with some other paths
  postPatch = ''
    substituteInPlace opt/balenaEtcher/resources/app/generated/gui.js \
      --replace '/usr/bin/pkexec' '/usr/bin/pkexec", "/run/wrappers/bin/pkexec' \
      --replace '/bin/bash' '${bash}/bin/bash' \
      --replace '"lsblk"' '"${util-linux}/bin/lsblk"'
  '';

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    udev
  ];

  dontConfigure = true;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/${pname}

    cp -a usr/share/* $out/share
    cp -a opt/balenaEtcher/{locales,resources} $out/share/${pname}

    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags $out/share/${pname}/resources/app

    substituteInPlace $out/share/applications/balena-etcher.desktop \
      --replace /opt/balenaEtcher/balena-etcher ${pname}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Flash OS images to SD cards and USB drives, safely and easily";
    homepage = "https://etcher.io/";
    license = licenses.asl20;
    mainProgram = pname;
    maintainers = with maintainers; [ wegank ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
