{ stdenv
, fetchurl
, gcc-unwrapped
, dpkg
, polkit
, utillinux
, bash
, nodePackages
, makeWrapper
, electron_7
}:

let
  sha256 = {
    "x86_64-linux" = "1yvqi86bw0kym401zwknhwq9041fxg047sbj3aydnfcqf11vrrmk";
    "i686-linux" = "12lghzhsl16h3jvzm3vw4hrly32fz99z6rdmybl8viralrxy8mb8";
  }."${stdenv.system}";

  arch = {
    "x86_64-linux" = "amd64";
    "i686-linux" = "i386";
  }."${stdenv.system}";

  electron = electron_7;

in

stdenv.mkDerivation rec {
  pname = "etcher";
  version = "1.5.86";

  src = fetchurl {
    url = "https://github.com/balena-io/etcher/releases/download/v${version}/balena-etcher-electron_${version}_${arch}.deb";
    inherit sha256;
  };

  dontBuild = true;
  dontConfigure = true;

  nativeBuildInputs = [ makeWrapper ];

  unpackPhase = ''
    ${dpkg}/bin/dpkg-deb -x $src .
  '';

  # sudo-prompt has hardcoded binary paths on Linux and we patch them here
  # along with some other paths
  patchPhase = ''
    ${nodePackages.asar}/bin/asar extract opt/balenaEtcher/resources/app.asar tmp
    # use Nix(OS) paths
    sed -i "s|/usr/bin/pkexec|/usr/bin/pkexec', '/run/wrappers/bin/pkexec|" tmp/node_modules/sudo-prompt/index.js
    sed -i 's|/bin/bash|${bash}/bin/bash|' tmp/node_modules/sudo-prompt/index.js
    sed -i "s|'lsblk'|'${utillinux}/bin/lsblk'|" tmp/node_modules/drivelist/js/lsblk/index.js
    sed -i "s|process.resourcesPath|'$out/share/${pname}/resources/'|" tmp/generated/gui.js
    ${nodePackages.asar}/bin/asar pack tmp opt/balenaEtcher/resources/app.asar
    rm -rf tmp
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/${pname}

    cp -a usr/share/* $out/share
    cp -a opt/balenaEtcher/{locales,resources} $out/share/${pname}

    substituteInPlace $out/share/applications/balena-etcher-electron.desktop \
      --replace 'Exec=/opt/balenaEtcher/balena-etcher-electron' 'Exec=${pname}'

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags $out/share/${pname}/resources/app.asar \
      --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ gcc-unwrapped.lib ]}"
  '';

  meta = with stdenv.lib; {
    description = "Flash OS images to SD cards and USB drives, safely and easily";
    homepage = "https://etcher.io/";
    license = licenses.asl20;
    maintainers = [ maintainers.shou ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
