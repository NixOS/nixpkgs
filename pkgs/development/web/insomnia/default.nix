{
  lib,
  stdenv,
  fetchurl,
  appimageTools
}:
let
  pname = "insomnia";
  version = "8.6.1";

  src = fetchurl {
    x86_64-darwin = {
      url = "https://github.com/Kong/insomnia/releases/download/core%40${version}/Insomnia.Core-${version}.dmg";
      hash = "sha256-4Y6e5cQ9J0enp2teXVNCvrjbhH130op45BVxZxA74JE";
    };
    x86_64-linux = {
      url = "https://github.com/Kong/insomnia/releases/download/core%40${version}/Insomnia.Core-${version}.AppImage";
      hash = lib.fakeHash;
    };
  }.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");

  meta = with lib; {
    homepage = "https://insomnia.rest";
    description = " The open-source, cross-platform API client for GraphQL, REST, WebSockets, SSE and gRPC. With Cloud, Local and Git storage. ";
    mainProgram = "insomnia";
    changelog = "https://github.com/Kong/insomnia/releases/tag/core@${version}";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ markus1189 babariviere kashw2 DataHearth ];
  };
in
if stdenv.isDarwin then stdenv.mkDerivation {
  inherit pname version src meta;
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
} else {
  inherit pname version src meta;

  extraInstallCommands = let
    appimageContents = appimageTools.extract {
      inherit pname version src;
    };
  in ''
    # Replace version from binary name
    mv $out/bin/${pname}-${version} $out/bin/${pname}
    # Install XDG Desktop file and its icon
    install -Dm444 ${appimageContents}/insomnia.desktop -t $out/share/applications
    install -Dm444 ${appimageContents}/insomnia.png -t $out/share/pixmaps
    # Replace wrong exec statement in XDG Desktop file
    substituteInPlace $out/share/applications/insomnia.desktop \
        --replace 'Exec=AppRun --no-sandbox %U' 'Exec=insomnia'
  '';
}
