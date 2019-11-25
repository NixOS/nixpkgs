{ stdenv, fetchurl, jdk, jre, swt, makeWrapper, xorg }:

let
  pname = "ipscan";
  version = "3.6.2";

  jar = fetchurl {
    url = "https://github.com/angryip/ipscan/releases/download/${version}/ipscan-linux64-${version}.jar";
    sha256 = "0fmrrxanw46g53jvlb50516jqwqjzky564bf3df9i3ymjffrfnw4";
  };

  jarName = "${pname}-${version}.jar";
  jarPath = "$out/share/java/${jarName}";
in stdenv.mkDerivation rec {
  inherit pname version;

  dontUnpack = true;

  buildInputs = [ makeWrapper jdk ];

  installPhase = ''
    mkdir -p $out/share/java
    ln -s ${jar} ${jarPath}
    makeWrapper ${jre}/bin/java $out/bin/ipscan \
      --prefix LD_LIBRARY_PATH : "$out/lib/:${stdenv.lib.makeLibraryPath [ swt xorg.libXtst ]}" \
      --add-flags "-Xmx256m -Djava.library.path=${swt}/lib -cp ${jar}:${swt}/jars/swt.jar net.azib.ipscan.Main"
  '';

  passthru.jar = jar;

  meta = with stdenv.lib; {
    description = "Fast and friendly network scanner";
    homepage = https://angryip.org;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ kylesferrazza ];
  };
}
