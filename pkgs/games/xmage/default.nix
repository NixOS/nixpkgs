{ lib
, stdenv
, fetchurl
, jdk8
, unzip
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xmage";
  version = "1.4.50V2";

  src = fetchurl {
    url =
      "https://github.com/magefree/mage/releases/download/xmage_${finalAttrs.version}/xmage_${finalAttrs.version}.zip";
    sha256 = "sha256-t1peHYwCRy3wiIIwOD3nUyoxSOxbw6B/g++A1ofIbmg=";
  };

  preferLocalBuild = true;

  unpackPhase = ''
    ${unzip}/bin/unzip $src
  '';

  installPhase = let
    strVersion = lib.substring 0 6 finalAttrs.version;
  in ''
    mkdir -p $out/bin
    cp -rv ./* $out

    cat << EOS > $out/bin/xmage
    exec ${jdk8}/bin/java -Xms256m -Xmx512m -XX:MaxPermSize=384m -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -jar $out/mage-client/lib/mage-client-${strVersion}.jar
    EOS

    chmod +x $out/bin/xmage
  '';

  meta = with lib; {
    description = "Magic Another Game Engine";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
    homepage = "http://xmage.de/";
  };

})

