{ mkDerivation
, bsdSetupHook, netbsdSetupHook, rsync
, make
}:

mkDerivation {
  path = "tools/make";
  sha256 = "0fh0nrnk18m613m5blrliq2aydciv51qhc0ihsj4k63incwbk90n";
  version = "9.2";

  buildInputs = [];
  nativeBuildInputs = [
    bsdSetupHook netbsdSetupHook rsync
  ];

  skipIncludesPhase = true;

  postPatch = ''
    patchShebangs $COMPONENT_PATH/configure
    ${make.postPatch}
  '';

  buildPhase = ''
    runHook preBuild

    sh ./buildmake.sh

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D nbmake $out/bin/nbmake
    ln -s $out/bin/nbmake $out/bin/make
    mkdir -p $out/share
    cp -r $BSDSRCDIR/share/mk $out/share/mk

    runHook postInstall
  '';

  extraPaths = [ make.src ] ++ make.extraPaths;
}
