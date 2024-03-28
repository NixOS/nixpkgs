{ stdenv, lib, fetchgit, makeWrapper, gradle_6, jre, ffmpeg
, rev, hash, version ? "git+${builtins.substring 0 7 rev}"
}:

stdenv.mkDerivation rec {
  pname = "crossfire-jxclient";
  inherit version;

  src = fetchgit {
    url = "https://git.code.sf.net/p/crossfire/jxclient";
    inherit rev hash;
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ gradle_6 makeWrapper ffmpeg ];

  # All the dependencies are vendored, so we can just invoke gradle and let it
  # emit the jar rather than needing something like gradle2nix.
  buildPhase = ''
    gradle :createJar
  '';

  installPhase = ''
    mkdir -pv $out/share/java $out/bin
    cp jxclient.jar $out/share/java/jxclient.jar

    makeWrapper ${jre}/bin/java $out/bin/crossfire-jxclient \
      --add-flags "-jar $out/share/java/jxclient.jar" \
      --set _JAVA_OPTIONS '-Dawt.useSystemAAFontSettings=on' \
      --set _JAVA_AWT_WM_NONREPARENTING 1
  '';

  meta = with lib; {
    description = "Java client for the Crossfire free MMORPG";
    homepage = "http://crossfire.real-time.com/";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ ToxicFrog ];
  };
}
