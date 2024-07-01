{ lib, stdenv, fetchurl, makeWrapper
, libzen, libmediainfo , jre8
}:

stdenv.mkDerivation rec {
  pname = "ums";
  version = "10.12.0";

  src = {
    i686-linux = fetchurl {
      url =  "mirror://sourceforge/project/unimediaserver/${version}/" + lib.toUpper "${pname}-${version}" + "-x86.tgz";
      sha256 = "0j3d5zcwwswlcr2vicmvnnr7n8cg3q46svz0mbmga4j3da4473i6";
    };
    x86_64-linux = fetchurl {
      url =  "mirror://sourceforge/project/unimediaserver/${version}/" + lib.toUpper "${pname}-${version}" + "-x86_64.tgz";
      sha256 = "06f96vkf593aasyfw458fa4x3rnai2k83vpgzc83hlwr0rw70qfn";
   };
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    cp -a . $out/
    mkdir $out/bin
    mv $out/documentation /$out/doc

    # ums >= 9.0.0 ships its own JRE in the package. if we remove it, the `UMS.sh`
    # script will correctly fall back to the JRE specified by JAVA_HOME
    rm -rf $out/jre8

    makeWrapper "$out/UMS.sh" "$out/bin/ums" \
      --prefix LD_LIBRARY_PATH ":" "${lib.makeLibraryPath [ libzen libmediainfo] }" \
      --set JAVA_HOME "${jre8}"
  '';

  meta = {
      description = "Universal Media Server: a DLNA-compliant UPnP Media Server";
      license = lib.licenses.gpl2Only;
      platforms = lib.platforms.linux;
      maintainers = with lib.maintainers; [ thall snicket2100 ];
      mainProgram = "ums";
  };
}
