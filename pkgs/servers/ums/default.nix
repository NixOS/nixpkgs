{ stdenv, fetchurl, makeWrapper
, libzen, libmediainfo , jre8
}:

stdenv.mkDerivation rec {
  name = "ums-${version}";
  version = "6.2.2";
  
  src = fetchurl {
    url = "mirror://sourceforge/project/unimediaserver/Official%20Releases/Linux/" + stdenv.lib.toUpper "${name}" + "-Java8.tgz";
    sha256 = "1qa999la9hixy0pdj9phjvr6lwqycgdvm94nc1606vz0ivf95b15";
    name = "${name}.tgz";
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    cp -a . $out/
    mkdir $out/bin
    mv $out/documentation /$out/doc

    makeWrapper "$out/UMS.sh" "$out/bin/ums" \
      --prefix LD_LIBRARY_PATH ":" "${stdenv.lib.makeLibraryPath [ libzen libmediainfo] }" \
      --set JAVA_HOME "${jre8}"
  '';

  meta = {
      description = "Universal Media Server: a DLNA-compliant UPnP Media Server";
      license = stdenv.lib.licenses.gpl2;
      platforms = stdenv.lib.platforms.linux;
      maintainers = [ stdenv.lib.maintainers.thall ];
  };
}
