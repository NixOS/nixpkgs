{
  lib,
  jre,
  unzip,
  stdenv,
  fetchurl,

  makeWrapper,
  makeDesktopItem,
  makeBinaryWrapper,

  copyDesktopItems,
  desktopToDarwinBundle,
}:

let
  icon = fetchurl {
    url = "https://www.kali.org/tools/jsql/images/jsql-logo.svg";
    hash = "sha256-qjr+9gMGSdYqDT2SZFt4i3vISrMjqvAlBTt7U6raTLc=";
  };

  pname = "jsql-injection";
  version = "0.111"; # ! Latest = v0.111
in
stdenv.mkDerivation {
  inherit
    pname
    version
    ;

  src = fetchurl {
    url = "https://github.com/ron190/jsql-injection/releases/download/v${version}/jsql-injection-v${version}.jar";
    sha256 = "sha256-TQWhlD1xbW5Xxdy5yf6P6aAMHkodM4qEfP9CGRs73MA=";
  };

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [
    jre
  ];

  dontUnpack = true;

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = "jSQL Injection";
      exec = pname;
      icon = pname;
      comment = "Java tool for automatic SQL database injection";
      categories = [
        "Development"
        "Security"
      ];
    })
  ];

  installPhase = ''
    runHook preInstall

    # Create necessary directories
    mkdir -p $out/share/{applications,${pname}}
    mkdir -p $out/bin

    # Install the JAR file
    cp $src $out/share/${pname}/${pname}.jar

    # Create wrapper
    makeWrapper ${jre}/bin/java $out/bin/${pname} \
      --add-flags "-jar $out/share/${pname}/${pname}.jar"

    # Install icon
    install -Dm444 ${icon} $out/share/icons/hicolor/scalable/apps/${pname}.svg

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/ron190/jsql-injection/releases/tag/v${version}";
    homepage = "https://github.com/ron190/jsql-injection";
    description = "Java tool for automatic SQL database injection";
    mainProgram = pname;
    maintainers = with lib.maintainers; [ Masrkai ];
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
  };
}
