{ stdenv
, lib
, callPackage
, jre
, makeWrapper
, fetchSteamDepot
, symlinkJoin }:

let
  version = "b41";

  steamworks-sdk = fetchSteamDepot {
    name = "steamworks-sdk";
    appId = 380870;
    depotId = 1006;
    manifestId = 1145429015527304256;
    sha256 = "1y4lwxq2flqb7njha0ff0fag9iqd8asd1lgmq5b968bbw6adfx81";
  };

  pz-media = fetchSteamDepot {
    name = "pz-media";
    appId = 380870;
    depotId = 380871;
    manifestId = 597018528582984283;
    sha256 = "1p4606cg5bjh4jxid2ii0fpbij88xsl8yrhgsjzs9gmwa0jivjaz";
  };

  pz-linux = fetchSteamDepot {
    name = "pz-linux";
    appId = 380870;
    depotId = 380873;
    manifestId = 7058797271499103796;
    sha256 = "12d2c7vk9z5nj8lpdjx35amw5c23dgiz4drmjg9gy33jp9g67r0v";
  };

in stdenv.mkDerivation rec {
  pname = "pz-server";
  inherit version;

  src = symlinkJoin {
    name = "pz-server";
    paths = [ pz-media pz-linux steamworks-sdk ];
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    jre
  ];

  installPhase = let
    shareDir = "$out/share/pz-server";
  in ''
    mkdir -p ${shareDir}
    cp -Lr $src/* ${shareDir}

    makeWrapper ${jre}/bin/java $out/bin/pz-server \
    --run "cd ${shareDir}" \
    --prefix LD_PRELOAD : libjsig.so \
    --prefix LD_LIBRARY_PATH : ${shareDir}/linux64 \
    --add-flags "-Dzomboid.steam=1 -Dzomboid.znetlog=1" \
    --add-flags "-Djava.awt.headless=true" \
    --add-flags "-Djava.library.path=${shareDir}/.:${shareDir}/natives:${shareDir}/linux64" \
    --add-flags "-Djava.security.egd=file:/dev/urandom" \
    --add-flags "-XX:+UseZGC" \
    --add-flags "-XX:-OmitStackTraceInFastThrow" \
    --add-flags "-cp ${shareDir}/java/.:${shareDir}/java/*" \
    --add-flags "zombie.network.GameServer"
  '';

  meta = with lib; {
    description = "The Ultimate Zombie Survival RPG";
    homepage    = "https://projectzomboid.com/";
    license     = licenses.unfree;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ kritnich ];
  };
}

