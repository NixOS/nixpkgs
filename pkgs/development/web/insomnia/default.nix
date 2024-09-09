{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
}:
let
  pname = "insomnia";
  version = "9.3.3";

  src =
    fetchurl
      {
        x86_64-darwin = {
          url = "https://github.com/Kong/insomnia/releases/download/core%40${version}/Insomnia.Core-${version}.dmg";
          hash = "sha256-nRrBOHLng/hH2+QhL4JyjKxjYTNXoUk9finfVRbakSg=";
        };
        x86_64-linux = {
          url = "https://github.com/Kong/insomnia/releases/download/core%40${version}/Insomnia.Core-${version}.AppImage";
          hash = "sha256-VzZCGyu8r27/eD3dIQRIW2YQCdO9IB+r+p/OEIU412g=";
        };
      }
      .${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");

  meta = {
    homepage = "https://insomnia.rest";
    description = " The open-source, cross-platform API client for GraphQL, REST, WebSockets, SSE and gRPC. With Cloud, Local and Git storage.";
    mainProgram = "insomnia";
    changelog = "https://github.com/Kong/insomnia/releases/tag/core@${version}";
    license = lib.licenses.asl20;
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
    maintainers = with lib.maintainers; [
      markus1189
      kashw2
      DataHearth
    ];
  };
in
if stdenv.isDarwin then
  stdenv.mkDerivation {
    inherit
      pname
      version
      src
      meta
      ;
    sourceRoot = ".";

    unpackCmd = ''
      echo "Creating temp directory"
      mnt=$(TMPDIR=/tmp mktemp -d -t nix-XXXXXXXXXX)
      function finish {
        echo "Ejecting temp directory"
        /usr/bin/hdiutil detach $mnt -force
        rm -rf $mnt
      }
      # Detach volume when receiving SIG "0"
      trap finish EXIT
      # Mount DMG file
      echo "Mounting DMG file into \"$mnt\""
      /usr/bin/hdiutil attach -nobrowse -mountpoint $mnt $curSrc
      # Copy content to local dir for later use
      echo 'Copying extracted content into "sourceRoot"'
      cp -a $mnt/Insomnia.app $PWD/
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/Applications"
      mv Insomnia.app $out/Applications/
      runHook postInstall
    '';
  }
else
  appimageTools.wrapType2 {
    inherit
      pname
      version
      src
      meta
      ;

    extraInstallCommands =
      let
        appimageContents = appimageTools.extract { inherit pname version src; };
      in
      ''
        # Install XDG Desktop file and its icon
        install -Dm444 ${appimageContents}/insomnia.desktop -t $out/share/applications
        install -Dm444 ${appimageContents}/insomnia.png -t $out/share/pixmaps
        # Replace wrong exec statement in XDG Desktop file
        substituteInPlace $out/share/applications/insomnia.desktop \
            --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=insomnia'
      '';
  }
