{ lib, stdenv
, fetchurl
, gcc-unwrapped
, dpkg
, util-linux
, bash
, makeWrapper
, electron
}:

let
  inherit (stdenv.hostPlatform) system;

  throwSystem = throw "Unsupported system: ${stdenv.hostPlatform.system}";

  sha256 = {
    "x86_64-linux" = "1yj6ybc99nqpzv2wjmvi7khfb5viwlb2rbjdpvgr4pmlzmiv7n2k";
    "i686-linux" = "09ddcqxw1jhl8v461ngdgj2l4infn2xiwvaqxi6qp3swci627vmz";
  }."${system}" or throwSystem;

  arch = {
    "x86_64-linux" = "amd64";
    "i686-linux" = "i386";
  }."${system}" or throwSystem;

in

stdenv.mkDerivation rec {
  pname = "etcher";
  version = "1.7.3";

  src = fetchurl {
    url = "https://github.com/balena-io/etcher/releases/download/v${version}/balena-etcher-electron_${version}_${arch}.deb";
    inherit sha256;
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

    substituteInPlace $out/share/applications/balena-etcher-electron.desktop \
      --replace /opt/balenaEtcher/balena-etcher-electron ${pname}

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags $out/share/${pname}/resources/app \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ gcc-unwrapped.lib ]}"
  '';

  meta = with lib; {
    description = "Flash OS images to SD cards and USB drives, safely and easily";
    homepage = "https://etcher.io/";
    license = licenses.asl20;
    maintainers = [ maintainers.shou ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
