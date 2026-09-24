{
  mkDerivation,
  bsdSetupHook,
  netbsdSetupHook,
  make,
  make-rules,
}:

mkDerivation {
  path = "tools/make";

  buildInputs = [ ];
  nativeBuildInputs = [
    bsdSetupHook
    netbsdSetupHook
  ];

  skipIncludesPhase = true;

  postPatch = ''
    patchShebangs $COMPONENT_PATH/configure

    # make needs this to pick up our sys make files
    appendToVar NIX_CFLAGS_COMPILE "-D_PATH_DEFSYSPATH=\"$out/share/mk\""
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
    cp -r ${make-rules} $out/share/mk

    runHook postInstall
  '';

  extraPaths = [ make.path ];
}
