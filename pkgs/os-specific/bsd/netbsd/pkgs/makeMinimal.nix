{
  mkDerivation,
  bsdSetupHook,
  netbsdSetupHook,
  rsync,
  make,
  make-rules,
}:

mkDerivation {
  path = "tools/make";
  sha256 = "0fh0nrnk18m613m5blrliq2aydciv51qhc0ihsj4k63incwbk90n";
  version = "9.2";

  buildInputs = [ ];
  nativeBuildInputs = [
    bsdSetupHook
    netbsdSetupHook
    rsync
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

  extraPaths = [ make.src ];
}
