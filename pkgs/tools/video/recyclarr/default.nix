{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  autoPatchelfHook,
  fixDarwinDylibNames,
  darwin,
  recyclarr,
  git,
  icu,
  testers,
  zlib,
}:
let
  os = if stdenv.isDarwin then "osx" else "linux";

  arch =
    {
      x86_64-linux = "x64";
      aarch64-linux = "arm64";
      x86_64-darwin = "x64";
      aarch64-darwin = "arm64";
    }
    ."${stdenv.hostPlatform.system}" or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  hash =
    {
      x64-linux_hash = "sha256-Skf3wY52B6KnWS8YurAL0b5Sdkvp4YYn3IvHrAKyvK8=";
      arm64-linux_hash = "sha256-66OCz13eLyAfEC3kYUniqq+QhsHoZNBJieXmmsLG5eM=";
      x64-osx_hash = "sha256-6cNpfcjwgfxZRlBnZQrZLMPaXDHEXSbS3Z/qcx1Z3HA=";
      arm64-osx_hash = "sha256-OkM+LgqXOHzyzEWH6D3czH86Sncym9FpfTFaacp2aN0=";
    }
    ."${arch}-${os}_hash";

  libPath =
    {
      osx = "DYLD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          darwin.ICU
          zlib
        ]
      }";
      linux = "LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          icu
          zlib
        ]
      }";
    }
    ."${os}";

in
stdenv.mkDerivation rec {
  pname = "recyclarr";
  version = "6.0.2";

  src = fetchurl {
    url = "https://github.com/recyclarr/recyclarr/releases/download/v${version}/recyclarr-${os}-${arch}.tar.xz";
    inherit hash;
  };

  sourceRoot = ".";

  nativeBuildInputs =
    [ makeWrapper ]
    ++ lib.optional stdenv.isLinux autoPatchelfHook
    ++ lib.optional stdenv.isDarwin fixDarwinDylibNames;
  buildInputs = [
    icu
    zlib
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 recyclarr -t $out/bin

    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/recyclarr \
      --prefix PATH : ${lib.makeBinPath [ git ]} \
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
    mainProgram = "recyclarr";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
