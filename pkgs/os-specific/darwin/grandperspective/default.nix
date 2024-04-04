{ stdenv, lib, fetchurl, undmg, makeWrapper }:

stdenv.mkDerivation (finalAttrs: {
  version = "3.4.1";
  pname = "grandperspective";

  src = fetchurl {
    inherit (finalAttrs) version;
    url = "mirror://sourceforge/grandperspectiv/GrandPerspective-${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}.dmg";
    hash = "sha256-iTtvP6iONcfDWJ3qMh+TUJMN+3spwCQ/5S+A307BJCM=";
  };

  sourceRoot = "GrandPerspective.app";
  buildInputs = [ undmg ];
  nativeBuildInputs = [ makeWrapper ];
  # Create a trampoline script in $out/bin/ because a symlink doesn’t work for
  # this app.
  installPhase = ''
    mkdir -p "$out/Applications/GrandPerspective.app" "$out/bin"
    cp -R . "$out/Applications/GrandPerspective.app"
    makeWrapper "$out/Applications/GrandPerspective.app/Contents/MacOS/GrandPerspective" "$out/bin/grandperspective"
  '';

  meta = with lib; {
    description = "Open-source macOS application to analyze disk usage";
    longDescription = ''
      GrandPerspective is a small utility application for macOS that graphically shows the disk usage within a file
      system. It can help you to manage your disk, as you can easily spot which files and folders take up the most
      space. It uses a so called tree map for visualisation. Each file is shown as a rectangle with an area proportional to
      the file's size. Files in the same folder appear together, but their placement is otherwise arbitrary.
    '';
    mainProgram = "grandperspective";
    homepage = "https://grandperspectiv.sourceforge.net";
    license = licenses.gpl2Only;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ eliandoran ];
    platforms = platforms.darwin;
  };

})
