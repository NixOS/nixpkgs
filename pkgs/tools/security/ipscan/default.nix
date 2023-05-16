{ lib
, stdenv
, fetchurl
, jdk
, jre
, swt
, makeWrapper
, xorg
, dpkg
}:

stdenv.mkDerivation rec {
  pname = "ipscan";
<<<<<<< HEAD
  version = "3.9.1";

  src = fetchurl {
    url = "https://github.com/angryip/ipscan/releases/download/${version}/ipscan_${version}_amd64.deb";
    hash = "sha256-UPkUwZV3NIeVfL3yYvqOhm4X5xW+40GOlZGy8WGhYmk=";
=======
  version = "3.9.0";

  src = fetchurl {
    url = "https://github.com/angryip/ipscan/releases/download/${version}/ipscan_${version}_all.deb";
    sha256 = "sha256-HpsEp5XSz118cbV2wT81hzQT4cgDEBnpUbpl45ZVvlg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  sourceRoot = ".";
  unpackCmd = "${dpkg}/bin/dpkg-deb -x $src .";

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ jdk ];

  installPhase = ''
    mkdir -p $out/share
<<<<<<< HEAD
    cp usr/lib/ipscan/ipscan-linux64-${version}.jar $out/share/${pname}-${version}.jar
=======
    cp usr/lib/ipscan/ipscan-any-${version}.jar $out/share/${pname}-${version}.jar
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    makeWrapper ${jre}/bin/java $out/bin/ipscan \
      --prefix LD_LIBRARY_PATH : "$out/lib/:${lib.makeLibraryPath [ swt xorg.libXtst ]}" \
      --add-flags "-Xmx256m -cp $out/share/${pname}-${version}.jar:${swt}/jars/swt.jar net.azib.ipscan.Main"

    mkdir -p $out/share/applications
    cp usr/share/applications/ipscan.desktop $out/share/applications/ipscan.desktop
    substituteInPlace $out/share/applications/ipscan.desktop --replace "/usr/bin" "$out/bin"

    mkdir -p $out/share/pixmaps
    cp usr/share/pixmaps/ipscan.png $out/share/pixmaps/ipscan.png
  '';

  meta = with lib; {
<<<<<<< HEAD
    description = "Angry IP Scanner - fast and friendly network scanner";
    homepage = "https://angryip.org";
    downloadPage = "https://github.com/angryip/ipscan/releases/tag/${version}";
=======
    description = "Fast and friendly network scanner";
    homepage = "https://angryip.org";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    changelog = "https://github.com/angryip/ipscan/blob/${version}/CHANGELOG";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.gpl2Only;
    platforms = [ "x86_64-linux" ];
<<<<<<< HEAD
    maintainers = with maintainers; [ kylesferrazza totoroot ];
=======
    maintainers = with maintainers; [ kylesferrazza ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
