{ fetchzip
, lib
, stdenv
, copyDesktopItems
, makeDesktopItem
, jre
}:
let
  vPath = v: lib.elemAt (lib.splitString "-" v) 0;

  arch = let inherit (stdenv.targetPlatform) system;
         in if system == "x86_64-linux" then "x64"
            else if system == "aarch64=linux" then "arm64"
            else throw "Unsupported system";

  desktopItem = makeDesktopItem {
    name = "Yourkit JavaProfiler";
    exec = "yourkit-java-profiler";
    comment = "Award winning, fully featured low overhead profiler for Java EE and Java SE platforms";
    desktopName = "YourKit JavaProfiler";
    type = "Application";
    icon = "yourkit-java-profiler";
    terminal = false;
    categories = [ "Development" ];
    startupWMClass = "yourkit-java-profiler";
    startupNotify = false;
  };
in
stdenv.mkDerivation rec {
  pname = "yourkit-java";

  version = "2023.9-b103";

  src = fetchzip {
    url = "https://download.yourkit.com/yjp/${vPath version}/YourKit-JavaProfiler-${version}-${arch}.zip";
    hash = "sha256-fJk39cQEU924FViCwTcISIyhiwJEviVeqxLiNQifRis=";
  };

  buildInputs = [ jre ];

  nativeBuildInputs = [ copyDesktopItems ];

  desktopItems = [ desktopItem ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -pr bin lib license.html license-redist.txt probes samples $out
    for i in attach integrate; do
        sed -i -e 's|profiler.sh|yourkit-java-profiler|' $out/bin/$i.sh
    done
    for i in attach integrate profiler; do
        mv $out/bin/$i.sh $out/bin/yourkit-java-$i
    done
    mv $out/bin/profiler.ico $out/bin/yourkit-java-profiler.ico
    sed -i -e 's|JAVA_EXE="$YD/jre64/bin/java"|JAVA_EXE=${jre}/bin/java|' \
        $out/bin/yourkit-java-profiler

    runHook postInstall
  '';

  meta = with lib; {
    description = "Award winning, fully featured low overhead profiler for Java EE and Java SE platforms";
    homepage = "https://www.yourkit.com";
    changelog = "https://www.yourkit.com/changes/";
    license = licenses.unfree;
    mainProgram = "yourkit-java-profiler";
    platforms = platforms.linux;
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    maintainers = with maintainers; [ herberteuler ];
  };
}
