{ stdenv
, lib
, fetchurl
, dpkg
, autoPatchelfHook
, copyDesktopItems
, makeDesktopItem
, jdk11
}:

stdenv.mkDerivation rec {
  pname = "muon-ssh";
  version = "2.2.0";

  src = fetchurl {
    url = "https://github.com/devlinx9/muon-ssh/releases/download/v2.2.0/muonssh_2.2.0.deb";
    sha256 = "cd7bbbb27f75f5538cef2ab599435251493023222086e165086b57f3ed6fac3a";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    copyDesktopItems
    jdk11
  ];

  buildInputs = [
    stdenv.cc.cc.lib
  ];

  unpackPhase = ''
    dpkg-deb -x ${src} ./
  '';

  installPhase = ''
    runHook preInstall

    mv usr $out
    mv opt $out

    sed -i -e "s|/opt/muonssh/muonssh.jar.*$|$out/opt/muonssh/muonssh.jar|" $out/bin/muonssh
    sed -i -e "s|Exec=/usr/bin/muonssh.*$|Exec=$out/bin/muonssh|" $out/share/applications/muonssh.desktop
  '';

  meta = with lib; {
    description = "Easy and fun way to work with remote servers over SSH.";
    homepage = "https://github.com/devlinx9/muon-ssh";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      devpikachu
    ];
    platforms = [ "x86_64-linux" ];
  };
}
