{ fetchzip
, lib
, stdenv
, copyDesktopItems
, imagemagick
, makeDesktopItem
, jre
}:
let
  vPath = v: lib.elemAt (lib.splitString "-" v) 0;

  arch = let inherit (stdenv.targetPlatform) system;
         in if system == "x86_64-linux" then "x64"
            else if system == "aarch64=linux" then "arm64"
            else throw "Unsupported system";

  version = "2023.9-b103";

  desktopItem = makeDesktopItem {
    name = "YourKit Java Profiler";
    desktopName = "YourKit Java Profiler " + version;
    type = "Application";
    exec = "yourkit-java-profiler";
    icon = "yourkit-java-profiler";
    categories = [ "Development" "Java" "Profiling" ];
    terminal = false;
    startupWMClass = "YourKit Java Profiler";
  };
in
stdenv.mkDerivation rec {
  inherit version;

  pname = "yourkit-java";

  src = fetchzip {
    url = "https://download.yourkit.com/yjp/${vPath version}/YourKit-JavaProfiler-${version}-${arch}.zip";
    hash = "sha256-fJk39cQEU924FViCwTcISIyhiwJEviVeqxLiNQifRis=";
  };

  nativeBuildInputs = [ copyDesktopItems imagemagick ];

  buildInputs = [ jre ];

  desktopItems = [ desktopItem ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -pr bin lib license.html license-redist.txt probes samples $out
    cp ${./forbid-desktop-item-creation} $out/bin/forbid-desktop-item-creation
    for i in attach integrate; do
        sed -i -e 's|profiler.sh|yourkit-java-profiler|' $out/bin/$i.sh
    done
    for i in attach integrate profiler; do
        mv $out/bin/$i.sh $out/bin/yourkit-java-$i
    done
    mkdir -p $out/share/icons
    convert $out/bin/profiler.ico\[0] \
            -size 256x256 \
            $out/share/icons/yourkit-java-profiler.png
    rm $out/bin/profiler.ico
    sed -i -e 's|JAVA_EXE="$YD/jre64/bin/java"|JAVA_EXE=${jre}/bin/java|' \
        $out/bin/yourkit-java-profiler
    # Use our desktop item, which will be purged when this package
    # gets removed
    sed -i -e "/^YD=/isource $out/bin/forbid-desktop-item-creation\\
        " \
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
