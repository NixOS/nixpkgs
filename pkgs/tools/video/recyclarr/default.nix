{ lib
, stdenv
, fetchurl
, makeWrapper
, autoPatchelfHook
, fixDarwinDylibNames
, darwin
, recyclarr
, git
, icu
, testers
, zlib
}:
let
  os =
    if stdenv.isDarwin
    then "osx"
    else "linux";

  arch = {
    x86_64-linux = "x64";
    aarch64-linux = "arm64";
    x86_64-darwin = "x64";
    aarch64-darwin = "arm64";
  }."${stdenv.hostPlatform.system}"
    or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  hash = {
    x64-linux_hash = "sha256-4xBT4IuonAQPSPKedecNd6YjoOh6pe3nCXMXpNBWP1g=";
    arm64-linux_hash = "sha256-4s/W1Xz0M1L6xm79AJy836OhNmW0Z4YoRsc7Qd5EwaM=";
    x64-osx_hash = "sha256-IQgKbZrINt6K3ezS+XjUEYoDIYtngvo++RTpCk+SeSc=";
    arm64-osx_hash = "sha256-9vHzGAH+fbn+x3lm3/UuNfd0Fv8s2MPPGSe5VnaASeg=";
  }."${arch}-${os}_hash";

  libPath = {
    osx = "DYLD_LIBRARY_PATH : ${lib.makeLibraryPath [darwin.ICU zlib]}";
    linux = "LD_LIBRARY_PATH : ${lib.makeLibraryPath [icu zlib]}";
  }."${os}";

in
stdenv.mkDerivation rec {
  pname = "recyclarr";
  version = "6.0.1";

  src = fetchurl {
    url = "https://github.com/recyclarr/recyclarr/releases/download/v${version}/recyclarr-${os}-${arch}.tar.xz";
    inherit hash;
  };

  sourceRoot = ".";

  nativeBuildInputs = [ makeWrapper ]
    ++ lib.optional stdenv.isLinux autoPatchelfHook
    ++ lib.optional stdenv.isDarwin fixDarwinDylibNames;
  buildInputs = [ icu zlib ];

  installPhase = ''
    runHook preInstall

    install -Dm755 recyclarr -t $out/bin

    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/recyclarr \
      --prefix PATH : ${lib.makeBinPath [git]} \
      --prefix ${libPath}
  '';

  dontStrip = true; # stripping messes up dotnet single-file deployment

  passthru = {
    updateScript = ./update.sh;
    tests.version = testers.testVersion {
      package = recyclarr;
    };
  };

  meta = with lib; {
    description = "Automatically sync TRaSH guides to your Sonarr and Radarr instances";
    homepage = "https://recyclarr.dev/";
    changelog = "https://github.com/recyclarr/recyclarr/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ josephst ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
}
