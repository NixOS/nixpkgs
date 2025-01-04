{ lib
, stdenv
, fetchFromGitHub
, autoPatchelfHook
, stripJavaArchivesHook
, maven
, jre
, glib
, libsecret
, webkitgtk_4_1
, makeWrapper
, nixosTests
}:

maven.buildMavenPackage rec {
  pname = "archi";
  version = "5.4.3";

  src = fetchFromGitHub {
    owner = "archimatetool";
    repo = "archi";
    rev = "release_${version}";
    hash = "sha256-+Tl7SyxwoffqlYdQSArDILimPDUWW4lnEpwkCO5OQ3I=";
  };

  mvnHash = "sha256-Bx+Nw4fGQoLr7+flrxPzxiPJC5fr6z3dr/hnlZ553JE=";

  buildInputs = [
    libsecret
  ];

  nativeBuildInputs = [
    makeWrapper
    autoPatchelfHook
    stripJavaArchivesHook
  ];

  mvnParameters = lib.escapeShellArgs [
    "-Pproduct"
    "-Dproject.build.outputTimestamp=1980-01-01T00:00:02Z"
  ];

  installPhase = ''
    p_sys=${if stdenv.hostPlatform.isLinux then "linux/gtk" else "macosx/cocoa"}
    p_arch=${if stdenv.hostPlatform.isx86 then "x86_64" else "aarch64"}
    p_postfix=${if stdenv.hostPlatform.isLinux then "Archi" else ""}

    cd com.archimatetool.editor.product/target/products/com.archimatetool.editor.product/$p_sys/$p_arch/$p_postfix/

  '' + (if stdenv.hostPlatform.isLinux then
    ''
      mkdir -p $out/bin $out/share $out/libexec


      for f in configuration features p2 plugins Archi.ini; do
        cp -r $f $out/libexec
      done

      install -D -m755 Archi $out/libexec/Archi
      makeWrapper $out/libexec/Archi $out/bin/Archi \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath ([ glib webkitgtk_4_1 ])} \
        --set WEBKIT_DISABLE_DMABUF_RENDERER 1 \
        --prefix PATH : ${jre}/bin
    ''
  else
    ''
      mkdir -p "$out/Applications"
      mv Archi.app "$out/Applications/"
    '');

  passthru.tests = { inherit (nixosTests) archi; };

  meta = with lib; {
    description = "ArchiMate modelling toolkit";
    longDescription = ''
      Archi is an open source modelling toolkit to create ArchiMate
      models and sketches.
    '';
    homepage = "https://www.archimatetool.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ earldouglas paumr ];
    mainProgram = "Archi";
  };
}
