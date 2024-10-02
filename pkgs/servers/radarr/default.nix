{ lib, stdenv, fetchurl, mono, libmediainfo, sqlite, curl, makeWrapper, icu, dotnet-runtime, openssl, nixosTests, zlib }:

let
  os = if stdenv.hostPlatform.isDarwin then "osx" else "linux";
  arch = {
    x86_64-linux = "x64";
    aarch64-linux = "arm64";
    x86_64-darwin = "x64";
    aarch64-darwin = "arm64";
  }."${stdenv.hostPlatform.system}" or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  hash = {
    x64-linux_hash = "sha256-ZI4ALGEdc9ZBUp8TnvzzbejxVBy61WAIxlbp0VYyc7M=";
    arm64-linux_hash = "sha256-qN8CNV10q5JP+f1XdfsgCqnpbhzFlCPbM3TIAnGh9U8=";
    x64-osx_hash = "sha256-u7Ny3ppD/mdIKk+I/ywsk1bS7EjEt63mbvzaM8MpoCE=";
    arm64-osx_hash = "sha256-k5iOzyicXpoCWotGvC/J8euh0OQOuKLxU6OTWiWmWc8=";
  }."${arch}-${os}_hash";

in stdenv.mkDerivation rec {
  pname = "radarr";
  version = "5.11.0.9244";

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
    description = "Usenet/BitTorrent movie downloader";
    homepage = "https://radarr.video/";
    changelog = "https://github.com/Radarr/Radarr/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ edwtjo purcell ];
    mainProgram = "Radarr";
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
}
