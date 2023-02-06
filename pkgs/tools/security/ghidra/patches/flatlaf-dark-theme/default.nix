{ lib
, stdenv
, fetchMavenArtifact
, ghidra
}:

# based on https://github.com/zackelia/ghidra-dark
stdenv.mkDerivation rec {
  pname = "ghidra-patch-flatlaf-dark-theme";
  version = "3.0";
  src = fetchMavenArtifact {
    artifactId = "flatlaf";
    groupId = "com.formdev";
    sha256 = "sha256-lpsnqmEscOy4VmTlXYxfdnimGI+dt8UUKoH25HXhmGc=";
    inherit version;
  };
  buildPhase = ''
    d=lib/ghidra/Ghidra
    mkdir -p $out/$d
    cd $out/$d
    mkdir patch
    ln -s ${src}/share/java/flatlaf-*.jar patch
  '';
  dontInstall = true;
  passthru = {
    postPatch = ''
      replaceSymlinkWithFile() {
        if [ -L "$1" ]; then
          cp --remove-destination "$(readlink "$1")" "$1"
        fi
      }

      d=lib/ghidra/support
      cd $out/$d
      f=launch.properties
      s='VMARGS=-Dswing.systemlaf=com.formdev.flatlaf.FlatDarkLaf'
      if ! grep -q -x -F "$s" $f; then
        replaceSymlinkWithFile $f
        chmod +w $f
        printf "%s\n" "$s" >> $f
      fi
    '';
  };
  meta = with lib; {
    description = "Flat themes for Java Swing desktop applications";
    longDescription = ''
      FlatLaf comes with Light, Dark, IntelliJ and Darcula themes,
      scales on HiDPI displays and runs on Java 8 or newer.
    '';
    homepage = "https://github.com/JFormDesigner/FlatLaf";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
