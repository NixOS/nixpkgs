{ lib, stdenv
, fetchurl
, gcc-unwrapped
, dpkg
, util-linux
, bash
, makeWrapper
, electron_12
}:

let
  sha256 = {
    "x86_64-linux" = "sha256-Tasynkzyy8UIalQn6qhIuPWDflf4pL76D2czgEijrPw=";
    "i686-linux" = "0z6y45sz086njpywg7f0jn6n02qynb1qbi889g2kcgwbfjvmcpm1";
  }."${stdenv.system}";

  arch = {
    "x86_64-linux" = "amd64";
    "i686-linux" = "i386";
  }."${stdenv.system}";

  electron = electron_12;

in

stdenv.mkDerivation rec {
  pname = "etcher";
  version = "1.5.122";

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
