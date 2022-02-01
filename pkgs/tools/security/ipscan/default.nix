{ lib, stdenv, fetchurl, jdk, jre, swt, makeWrapper, xorg, dpkg }:

stdenv.mkDerivation rec {
  pname = "ipscan";
  version = "3.8.2";

  src = fetchurl {
    url = "https://github.com/angryip/ipscan/releases/download/${version}/ipscan_${version}_all.deb";
    sha256 = "sha256-064V1KnMXBnjgM6mBrwkezdl+Tko3Xri0D4fCk9iPbk=";
  };

  sourceRoot = ".";
  unpackCmd = "${dpkg}/bin/dpkg-deb -x $src .";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jdk ];

  installPhase = ''
    mkdir -p $out/share
    cp usr/lib/ipscan/ipscan-any-${version}.jar $out/share/${pname}-${version}.jar

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
    description = "Fast and friendly network scanner";
    homepage = "https://angryip.org";
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ kylesferrazza ];
  };
}
