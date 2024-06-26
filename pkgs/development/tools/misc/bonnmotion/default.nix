{
  stdenv,
  lib,
  fetchzip,
  substituteAll,
  bash,
  jre,
}:

stdenv.mkDerivation rec {
  pname = "bonnmotion";
  version = "3.0.1";

  src = fetchzip {
    url = "https://sys.cs.uos.de/bonnmotion/src/bonnmotion-${version}.zip";
    sha256 = "16bjgr0hy6an892m5r3x9yq6rqrl11n91f9rambq5ik1cxjqarxw";
  };

  patches = [
    # The software has a non-standard install bash script which kind of works.
    # However, to make it fully functional, the automatically detection of the
    # program paths must be substituted with full paths.
    (substituteAll {
      src = ./install.patch;
      inherit bash jre;
    })
  ];

  installPhase = ''
    runHook preInstall

    ./install

    mkdir -p $out/bin $out/share/bonnmotion
    cp -r ./classes ./lib $out/share/bonnmotion/
    cp ./bin/bm $out/bin/

    substituteInPlace $out/bin/bm \
      --replace /build/source $out/share/bonnmotion

    runHook postInstall
  '';

  meta = with lib; {
    description = "Mobility scenario generation and analysis tool";
    mainProgram = "bm";
    longDescription = ''
      BonnMotion is a Java software which creates and analyzes mobility
      scenarios and is most commonly used as a tool for the investigation of
      mobile ad hoc network characteristics. The scenarios can also be exported
      for several network simulators, such as ns-2, ns-3, GloMoSim/QualNet,
      COOJA, MiXiM, and ONE.
    '';
    homepage = "https://sys.cs.uos.de/bonnmotion/";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode # source bundles dependency jars
    ];
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ oxzi ];
  };
}
