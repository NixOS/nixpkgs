{ fetchzip
, lib
, stdenv
, jdk17
}:
let jre = jdk17;
    vPath = v: lib.elemAt (lib.splitString "-" v) 0;
    arch = if stdenv.targetPlatform.system == "x86_64-linux"
           then "x64"
           else if stdenv.targetPlatform.system == "aarch64-linux"
           then "arm64"
           else throw "Unsupported system";
in
stdenv.mkDerivation rec {
  pname = "YourKit-JavaProfiler";
  version = "2023.9-b103";
  src = fetchzip {
    url = "https://download.yourkit.com/yjp/${vPath version}/${pname}-${version}-${arch}.zip";
    hash = "sha256-fJk39cQEU924FViCwTcISIyhiwJEviVeqxLiNQifRis=";
  };

  buildInputs = [ jre ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    sed -i -e 's|JAVA_EXE="$YD/jre64/bin/java"|JAVA_EXE=${jdk17}/bin/java|' bin/profiler.sh
    cp -pr bin lib license.html license-redist.txt probes samples $out
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.yourkit.com";
    description = "Award winning, fully featured low overhead profiler for Java EE and Java SE platforms";
    license = licenses.unfree;
    maintainers = with maintainers; [ herberteuler ];
    platforms = platforms.linux;
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
  };
}
