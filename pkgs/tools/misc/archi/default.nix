{ lib, stdenv
, fetchzip
, autoPatchelfHook
, makeWrapper
, maven
, jdk
, libsecret
, webkitgtk
, wrapGAppsHook
}:

maven.buildMavenPackage rec {
  pname = "Archi";
  version = "5.1.0";

  src = fetchzip {
    url = "https://github.com/archimatetool/archi/archive/refs/tags/release_${version}.tar.gz";
    hash = "sha256-7Z/cSqMNf6DWyrdGWQ1PFNCo93PjWJbfKnNKjPG/2uU=";
  };

  mvnHash = "sha256-ROLPO6oim7w6RjBgbAyQhfnCerLJwVBwoOMwUqzgRHk=";

  buildInputs = [
    libsecret
  ];

  nativeBuildInputs = [
    makeWrapper
    wrapGAppsHook
  ] ++ lib.optional stdenv.hostPlatform.isLinux autoPatchelfHook;

  mvnParameters = lib.escapeShellArgs [
    "-Pproduct"
  ];

  installPhase =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      ''
        cd com.archimatetool.editor.product/target/products/com.archimatetool.editor.product/linux/gtk/x86_64/Archi/
        mkdir -p $out/bin $out/libexec
        for f in configuration features p2 plugins Archi.ini; do
          cp -r $f $out/libexec
        done

        install -D -m755 Archi $out/libexec/Archi
        makeWrapper $out/libexec/Archi $out/bin/Archi \
          --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath ([ webkitgtk ])} \
          --prefix PATH : ${jdk}/bin
      ''
    else if stdenv.hostPlatform.isDarwin then
      ''
        cd com.archimatetool.editor.product/target/products/com.archimatetool.editor.product/macosx/cocoa/${stdenv.hostPlatform.darwinArch}/
        mkdir -p "$out/Applications"
        mv Archi.app "$out/Applications/"
      ''
    else
      throw "Unsupported system";

  meta = with lib; {
    description = "ArchiMate modelling toolkit";
    longDescription = ''
      Archi is an open source modelling toolkit to create ArchiMate
      models and sketches.
    '';
    homepage = "https://www.archimatetool.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ earldouglas ];
  };
}
