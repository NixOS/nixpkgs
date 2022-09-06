# Usage notes:
#
# Enable `services.gvfs` to open PDFs, or install and configure one of
# the supported PDF viewers.
#
# Without this, you will get an unhelpful
# "The BROWSE action is not supported on the current platform"
{ lib
, stdenv
, fetchFromGitHub
, jdk17
, makeWrapper
, wrapGAppsHook
, copyDesktopItems
, glib
, gvfs
, makeDesktopItem
}:
stdenv.mkDerivation rec {
  pname = "gcs";
  version = "v4.37.1";

  src = fetchFromGitHub {
    owner = "richardwilkes";
    repo = "gcs";
    rev = version;
    sha256 = "sha256-znN2tBUp0yAvM6E4eTcfmV3KmzyYlrRMLZgc/Fg9tFc=";
  };

  nativeBuildInputs = [jdk17 makeWrapper wrapGAppsHook copyDesktopItems];
  buildInputs = [glib gvfs];

  # gcs uses a bespoke bundling "script" that internally calls the
  # built-in jpackage; while this may seem bad, it's significantly
  # nicer to package than the gradle mess your usual Java application
  # gets itself into.
  #
  # Either way, it doesn't have a configure script, but needs some
  # patches to use things in the nix env correctly.
  configurePhase = ''
    patchShebangs bundle.sh
    substituteInPlace bundle.sh --replace /bin/rm rm
  '';

  # Disable packaging of .deb/.rpm, just give us the raw package
  # contents.
  buildPhase = ''
    ./bundle.sh --unpackaged
  '';

  installPhase = let
    icon-install-command = size: ''
      install -Dm 0600 \
          out/dist/build/com.trollworks.gcs/images/app_${size}.png \
          $out/share/icons/hicolor/${size}x${size}/apps/GCS.png
    '';
    icon-sizes = ["16" "32" "48" "64" "128" "256" "512" "1024"];
    v = lib.removePrefix "v" version;
  in ''
    runHook preInstall

    install -Dm 0600 -t $out/share/java/ out/dist/modules/com.trollworks.gcs-${v}.jar
    install -Dm 0600 ${./mime-info.xml} $out/share/mime/packages/gcs-GCS-MimeInfo.xml

    ${lib.strings.concatMapStringsSep "\n" icon-install-command icon-sizes}

    runHook postInstall
  '';

  # Add a launcher script that wraps up gapps correctly so the file
  # picker works.
  preFixup = let
    v = lib.removePrefix "v" version;
  in ''
    makeWrapper ${jdk17}/bin/java $out/bin/gcs \
        ''${gappsWrapperArgs[@]} \
        --add-flags "-jar $out/share/java/com.trollworks.gcs-${v}.jar"
  '';

  # Done as part of `makeWrapper` instead.
  dontWrapGApps = true;

  # Technically jpackage has its own set of definitions for this, but
  # when using `--unpackaged` it never creates a .desktop file.
  #
  # Instead, manually extract the args from around here:
  # https://github.com/richardwilkes/gcs/blob/v4-java/bundler/bundler/Bundler.java#L628
  #
  # If you're feeling motivated, feel free to write a script that
  # implements exactly the .desktop creating part of jpackage or such.
  desktopItems = [
    (makeDesktopItem {
      name = "com.trollworks.gcs";
      desktopName = "GCS";
      categories = ["Game" "Utility" "RolePlaying"];
      comment = meta.description;
      icon = "GCS";
      exec = "gcs";

      mimeTypes = [
        "application/gcs.adm"
        "application/gcs.adq"
        "application/gcs.eqm"
        "application/gcs.eqp"
        "application/gcs.gcs"
        "application/gcs.gct"
        "application/gcs.not"
        "application/gcs.skl"
        "application/gcs.spl"
      ];
    })
  ];

  meta = with lib; {
    # Description differs subtly from the upstream one to conform with
    # nixpkgs requirements.
    description = "A stand-alone, interactive, character sheet editor for the GURPS 4th Edition roleplaying game system";
    homepage = "https://gurpscharactersheet.com/";
    sourceProvenance = with sourceTypes; [fromSource];
    license = licenses.mpl20;
    platforms = platforms.all;
    maintainers = with maintainers; [tlater];
  };

  # An update script is probably superfluous for the moment, since the
  # next release (version 5) will be moving to go, so the derivation
  # will have to be redone by hand no matter what.
  #
  # Testing this as a GUI application would be valuable, but I also
  # think that's overkill, and I'd rather not spend valuable CI time
  # on testing a GUI app that probably only has very, very few users
  # ;)
}
