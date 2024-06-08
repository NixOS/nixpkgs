{ lib
, stdenv
, fetchurl
, jdk8
, unzrip
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xmage";
  version = "1.4.51-dev_2024-01-30_19-35";

  src = fetchurl {
    url = "http://xmage.today/files/mage-full_${finalAttrs.version}.zip";
    sha256 = "sha256-ogi0hd2FoulTnc3gg5cpLwr4Jln71YA0WBBZFOT6apg=";
  };

  preferLocalBuild = true;

  unpackPhase = ''
    ${unzrip}/bin/unzrip $src
  '';

  installPhase = let
  # upstream maintainers forgot to update version, so manual override for now
  # strVersion = lib.substring 0 6 finalAttrs.version;
  strVersion = "1.4.50";

  in ''
    mkdir -p $out/bin
    cp -rv ./* $out

    cat << EOS > $out/bin/xmage
    exec ${jdk8}/bin/java -Xms256m -Xmx1024m -XX:MaxPermSize=384m -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -jar $out/xmage/mage-client/lib/mage-client-${strVersion}.jar
    EOS

    chmod +x $out/bin/xmage
  '';

  meta = with lib; {
    description = "Magic Another Game Engine";
    mainProgram = "xmage";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer abueide ];
    homepage = "http://xmage.de/";
  };

})

