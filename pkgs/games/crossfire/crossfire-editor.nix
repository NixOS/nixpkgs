{ stdenv, lib, fetchgit, makeWrapper, gradle_6, jre
, rev, hash, version ? "git+${builtins.substring 0 7 rev}"
}:

stdenv.mkDerivation rec {
  pname = "crossfire-editor";
  inherit version;

  src = fetchgit {
    url = "https://git.code.sf.net/p/gridarta/gridarta";
    inherit rev hash;
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ gradle_6 makeWrapper ];

  # Fixes dependency search for vendored dependencies without POM files.
  patches = [ ./crossfire-editor.patch ];

  # All the dependencies are vendored, so we can just invoke gradle and let it
  # emit the jar rather than needing something like gradle2nix.
  buildPhase = ''
    gradle :src:crossfire:createEditorJar
  '';

  installPhase = ''
    mkdir -pv $out/share/java $out/bin
    cp src/crossfire/build/libs/CrossfireEditor.jar $out/share/java/crossfire-editor.jar

    makeWrapper ${jre}/bin/java $out/bin/crossfire-editor \
      --add-flags "-jar $out/share/java/crossfire-editor.jar" \
      --set _JAVA_OPTIONS '-Dawt.useSystemAAFontSettings=on' \
      --set _JAVA_AWT_WM_NONREPARENTING 1
  '';

  meta = with lib; {
    description = "Graphical map and archetype editor for the Crossfire free MMORPG";
    homepage = "http://crossfire.real-time.com/";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ ToxicFrog ];
  };
}
