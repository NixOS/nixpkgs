{ lib
, stdenv
, fetchzip
, glib
, jre
, makeWrapper
, wrapGAppsHook3
}:

stdenv.mkDerivation rec {
  pname = "VASSAL";
  version = "3.7.14";

  src = fetchzip {
    url = "https://github.com/vassalengine/vassal/releases/download/${version}/${pname}-${version}-linux.tar.bz2";
    sha256 = "sha256-3P3f6X2c5lF1AizEs9z59MhLy0Ntg203rkPAkv+SBtw=";
  };

  buildInputs = [
    glib
  ];

  nativeBuildInputs = [
    makeWrapper
    wrapGAppsHook3
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/vassal $out/doc

    cp CHANGES LICENSE README.md $out
    cp -R lib/* $out/share/vassal
    cp -R doc/* $out/doc

    makeWrapper ${jre}/bin/java $out/bin/vassal \
      --add-flags "-Duser.dir=$out -cp $out/share/vassal/Vengine.jar \
      VASSAL.launch.ModuleManager"

    runHook postInstall
  '';

  # Don't move doc to share/, VASSAL expects it to be in the root
  forceShare = [ "man" "info" ];

  meta = with lib; {
      description = "Free, open-source boardgame engine";
      homepage = "https://vassalengine.org/";
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
      license = licenses.lgpl21Only;
      maintainers = with maintainers; [ tvestelind ];
      platforms = platforms.unix;
      mainProgram = "vassal";
  };
}
