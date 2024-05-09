{ lib, stdenv, fetchurl, mono, libmediainfo, sqlite, curl, makeWrapper, icu, dotnet-runtime, openssl, nixosTests, zlib }:

let
  os = if stdenv.isDarwin then "osx" else "linux";
  arch = {
    x86_64-linux = "x64";
    aarch64-linux = "arm64";
    x86_64-darwin = "x64";
    aarch64-darwin = "arm64";
  }."${stdenv.hostPlatform.system}" or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  hash = {
    x64-linux_hash = "sha256-eFJ31tZPxzK1Vx2EOZ1AMrzCUL7pXJIb5J1joL/ZIgs=";
    arm64-linux_hash = "sha256-BtxHBHc2dYYdqZxwga7K49aGfSq5a8Z1TLjMPH4ldlw=";
    x64-osx_hash = "sha256-GQ8wHU4wWu6fpjiLI9yQyMvhP1DS5FE+YQu2uLFdto4=";
    arm64-osx_hash = "sha256-AnZ+mGeafJsRb6Koj0+oaER8d6vuDQ0x+Wc1eflzupo=";
  }."${arch}-${os}_hash";

in stdenv.mkDerivation rec {
  pname = "radarr";
  version = "5.4.6.8723";

  src = fetchurl {
    url = "https://github.com/Radarr/Radarr/releases/download/v${version}/Radarr.master.${version}.${os}-core-${arch}.tar.gz";
    sha256 = hash;
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/${pname}-${version}}
    cp -r * $out/share/${pname}-${version}/.

    makeWrapper "${dotnet-runtime}/bin/dotnet" $out/bin/Radarr \
      --add-flags "$out/share/${pname}-${version}/Radarr.dll" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [
        curl sqlite libmediainfo mono openssl icu zlib ]}

    runHook postInstall
  '';

  passthru = {
    updateScript = ./update.sh;
    tests.smoke-test = nixosTests.radarr;
  };

  meta = with lib; {
    description = "A Usenet/BitTorrent movie downloader";
    homepage = "https://radarr.video/";
    changelog = "https://github.com/Radarr/Radarr/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ edwtjo purcell ];
    mainProgram = "Radarr";
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
}
