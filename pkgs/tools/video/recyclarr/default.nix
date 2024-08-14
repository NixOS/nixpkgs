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
, openssl
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
    x64-linux_hash = "sha256-LMAY1UIwvB+ne4rpwLKaYO6QGTwdiS3YBndr73zIzvQ=";
    arm64-linux_hash = "sha256-by3PSYdN7TPjA0Cx4pfzIbpZ/YVU1agfcuvuZh6mbfU=";
    x64-osx_hash = "sha256-/YqdlVktgbBUNdm+mAD053pf6wCMXYt6gQP+iTQdKqw=";
    arm64-osx_hash = "sha256-2RRQGNTztK14KDFRqgpagNCWTizHVNY67psaxFfyDZ4=";
  }."${arch}-${os}_hash";

  libPath = {
    osx = "DYLD_LIBRARY_PATH : ${lib.makeLibraryPath [darwin.ICU openssl zlib]}";
    linux = "LD_LIBRARY_PATH : ${lib.makeLibraryPath [icu openssl zlib]}";
  }."${os}";

in
stdenv.mkDerivation rec {
  pname = "recyclarr";
  version = "7.0.0";

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
      version = "v${version}";
    };
  };

  meta = with lib; {
    description = "Automatically sync TRaSH guides to your Sonarr and Radarr instances";
    homepage = "https://recyclarr.dev/";
    changelog = "https://github.com/recyclarr/recyclarr/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ josephst ];
    mainProgram = "recyclarr";
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
}
