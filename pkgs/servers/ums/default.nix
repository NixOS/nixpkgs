{ stdenv, fetchurl, makeWrapper
, libzen, libmediainfo , jre8
}:

stdenv.mkDerivation rec {
  pname = "ums";
  version = "9.4.2";

  src = {
    i686-linux = fetchurl {
      url =  "mirror://sourceforge/project/unimediaserver/${version}/" + stdenv.lib.toUpper "${pname}-${version}" + "-x86.tgz";
      sha256 = "0i319g2c3z9j131nwh5m92clgnxxxs3izplzhjb30bx4lldmjs1j";
    };
    x86_64-linux = fetchurl {
      url =  "mirror://sourceforge/project/unimediaserver/${version}/" + stdenv.lib.toUpper "${pname}-${version}" + "-x86_64.tgz";
      sha256 = "07wc0is86fdfyz4as3f17q8pfzl8x55ci65zvpls0a9rfyyvjjw3";
   };
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  buildInputs = [ makeWrapper ];

  installPhase = ''
    cp -a . $out/
    mkdir $out/bin
    mv $out/documentation /$out/doc

    # ums >= 9.0.0 ships its own JRE in the package. if we remove it, the `UMS.sh`
    # script will correctly fall back to the JRE specified by JAVA_HOME
    rm -rf $out/jre

    makeWrapper "$out/UMS.sh" "$out/bin/ums" \
      --prefix LD_LIBRARY_PATH ":" "${stdenv.lib.makeLibraryPath [ libzen libmediainfo] }" \
      --set JAVA_HOME "${jre8}"
  '';

  meta = {
      description = "Universal Media Server: a DLNA-compliant UPnP Media Server";
      license = stdenv.lib.licenses.gpl2;
      platforms = stdenv.lib.platforms.linux;
      maintainers = with stdenv.lib.maintainers; [ thall snicket2100 ];
  };
}
