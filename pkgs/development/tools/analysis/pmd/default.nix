{
  lib,
  stdenv,
  fetchurl,
  unzip,
  makeWrapper,
  openjdk,
}:

stdenv.mkDerivation rec {
  pname = "pmd";
  version = "6.55.0";

  src = fetchurl {
    url = "https://github.com/pmd/pmd/releases/download/pmd_releases/${version}/pmd-bin-${version}.zip";
    hash = "sha256-Iaz5bUPLQNWRyszMHCCmb8eW6t32nqYYEllER7rHoR0=";
  };

  nativeBuildInputs = [
    unzip
    makeWrapper
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 bin/run.sh $out/libexec/pmd
    install -Dm644 lib/*.jar -t $out/lib/pmd

    wrapProgram $out/libexec/pmd \
        --prefix PATH : ${openjdk.jre}/bin \
        --set LIB_DIR $out/lib/pmd

    for app in pmd cpd cpdgui designer bgastviewer designerold ast-dump; do
        makeWrapper $out/libexec/pmd $out/bin/$app --argv0 $app --add-flags $app
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "Extensible cross-language static code analyzer";
    homepage = "https://pmd.github.io/";
    changelog = "https://pmd.github.io/pmd-${version}/pmd_release_notes.html";
    platforms = platforms.unix;
    license = with licenses; [
      bsdOriginal
      asl20
    ];
  };
}
