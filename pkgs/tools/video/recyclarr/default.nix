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
    x64-linux_hash = "sha256-LSnMXNXQDx45AlQi1IBbMQBBgMc0gJsSa0GV5G5UBPk=";
    arm64-linux_hash = "sha256-KkWAPXHaGCc8hsAMohbO7R0ZcfySlu1z+dRjNICaH+Y=";
    x64-osx_hash = "sha256-cFerz4g2hPcIqOAeIURD06v6Wr+Rs0xpMHYmG8xl250=";
    arm64-osx_hash = "sha256-Kl7lcJUaNeJ/xyd4Fh0f5Li8AyxrcQQgDSfxB3j2L1g=";
  }."${arch}-${os}_hash";

  libPath = {
    osx = "DYLD_LIBRARY_PATH : ${lib.makeLibraryPath [darwin.ICU zlib]}";
    linux = "LD_LIBRARY_PATH : ${lib.makeLibraryPath [icu zlib]}";
  }."${os}";

in
stdenv.mkDerivation rec {
  pname = "recyclarr";
  version = "5.1.1";

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
