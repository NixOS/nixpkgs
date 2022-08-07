{ lib, stdenv
, fetchurl
, jdk8
, unzip
}:

stdenv.mkDerivation rec {
  name    = "xmage";
  version = "1.4.42V6";

  src = fetchurl {
    url    = "https://github.com/magefree/mage/releases/download/xmage_1.4.42V6/xmage_${version}.zip";
    sha256 = "14s4885ldi0rplqmab5m775plsqmmm0m89j402caiqm2q9mzvkhd";
  };

  preferLocalBuild = true;

  unpackPhase = ''
    ${unzip}/bin/unzip $src
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -rv ./* $out

    cat << EOS > $out/bin/xmage
exec ${jdk8}/bin/java -Xms256m -Xmx512m -XX:MaxPermSize=384m -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -jar $out/mage-client/lib/mage-client-1.4.42.jar
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

}

