{ stdenv, fetchurl, makeWrapper
, libzen, libmediainfo , jre8
}:

stdenv.mkDerivation rec {
  name = "ums-${version}";
  version = "5.4.0";
  
  src = fetchurl {
    url = "http://downloads.sourceforge.net/project/unimediaserver/Official%20Releases/Linux/" + stdenv.lib.toUpper "${name}" + "-Java8.tgz";
    sha256 = "0ryp26h7pyqing8pyg0xjrp1wm77wwgya4a7d00wczh885pk16kq";
    name = "${name}.tgz";
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    cp -a . $out/
    mkdir $out/bin
    mv $out/documentation /$out/doc

    makeWrapper "$out/UMS.sh" "$out/bin/ums" \
      --prefix LD_LIBRARY_PATH ":" "${libzen}/lib:${libmediainfo}/lib" \
      --set JAVA_HOME "${jre8}"
  '';

  meta = {
      description = "Universal Media Server: a DLNA-compliant UPnP Media Server";
      license = stdenv.lib.licenses.gpl2;
      platforms = stdenv.lib.platforms.linux;
      maintainers = [ stdenv.lib.maintainers.thall ];
  };
}
