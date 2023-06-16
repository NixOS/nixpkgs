{ lib
, stdenv
, fetchurl
, udev
, dpkg
, util-linux
, bash
, makeWrapper
, electron
}:

stdenv.mkDerivation rec {
  pname = "etcher";
  version = "1.18.4";

  src = fetchurl {
    url = "https://github.com/balena-io/etcher/releases/download/v${version}/balena-etcher_${version}_amd64.deb";
    hash = "sha256-k1Nnpma5wGUWBF7xUO93h0ltOdU1hXurMOghcWRFJlQ=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontConfigure = true;
  dontBuild = true;

  unpackPhase = ''
    ${dpkg}/bin/dpkg-deb -x $src .
  '';

  # sudo-prompt has hardcoded binary paths on Linux and we patch them here
  # along with some other paths
  postPatch = ''
    # use Nix(OS) paths
    substituteInPlace opt/balenaEtcher/resources/app/generated/gui.js \
      --replace '/usr/bin/pkexec' '/usr/bin/pkexec", "/run/wrappers/bin/pkexec' \
      --replace '/bin/bash' '${bash}/bin/bash' \
      --replace '"lsblk"' '"${util-linux}/bin/lsblk"'
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/${pname}

    cp -a usr/share/* $out/share
    cp -a opt/balenaEtcher/{locales,resources} $out/share/${pname}

    substituteInPlace $out/share/applications/balena-etcher.desktop \
      --replace /opt/balenaEtcher/balena-etcher ${pname}

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags $out/share/${pname}/resources/app \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc.lib udev ]}"
  '';

  meta = with lib; {
    description = "Flash OS images to SD cards and USB drives, safely and easily";
    homepage = "https://etcher.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ shou jared-davis ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
