{ stdenv, fetchurl, makeWrapper
, libzen, libmediainfo , jre8
}:

stdenv.mkDerivation rec {
  pname = "ums";
  version = "9.1.0";
  
  src = fetchurl {
    url = "mirror://sourceforge/project/unimediaserver/Official%20Releases/Linux/" + stdenv.lib.toUpper "${pname}-${version}" + ".tgz";
    sha256 = "07wprjpwqids96v5q5fhwcxqlg8jp1vy585vl2nqbfi1vf5v294s";
    name = "${pname}-${version}.tgz";
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    cp -a . $out/
    mkdir $out/bin
    mv $out/documentation /$out/doc

    # ums >= 9.0.0 ships its own JRE in the package. if we remove it, the `UMS.sh`
    # script will correctly fall back to the JRE specified by JAVA_HOME
    rm -rf $out/linux/jre-x64 $out/linux/jre-x86

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
