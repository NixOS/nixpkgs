{ lib, stdenv, fetchurl, mono, libmediainfo, sqlite, curl, chromaprint, makeWrapper, icu, dotnet-runtime, openssl, nixosTests, zlib }:

let
  os = if stdenv.hostPlatform.isDarwin then "osx" else "linux";
  arch = {
    x86_64-linux = "x64";
    aarch64-linux = "arm64";
    x86_64-darwin = "x64";
  }."${stdenv.hostPlatform.system}" or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  hash = {
    x64-linux_hash = "sha256-6tRpTSdKVqPrpmgttqTNfHG57eGvsJzTTFLHj8lvepw=";
    arm64-linux_hash = "sha256-7cpBN/7fTl0lnLcpZpiVq9Q788AvQm9G+MTli7t5QME=";
    x64-osx_hash = "sha256-UwBA5wWyiE0PUoTN6JzEIyyrJWWziZ5NAa4a/MN5LSs=";
  }."${arch}-${os}_hash";
in stdenv.mkDerivation rec {
  pname = "lidarr";
  version = "2.8.2.4493";

  src = fetchurl {
    url = "https://github.com/lidarr/Lidarr/releases/download/v${version}/Lidarr.master.${version}.${os}-core-${arch}.tar.gz";
    sha256 = hash;
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/${pname}-${version}}
    cp -r * $out/share/${pname}-${version}/.
    makeWrapper "${dotnet-runtime}/bin/dotnet" $out/bin/Lidarr \
      --add-flags "$out/share/${pname}-${version}/Lidarr.dll" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [
        curl sqlite libmediainfo icu  openssl zlib ]}

    runHook postInstall
  '';


  passthru = {
    updateScript = ./update.sh;
    tests.smoke-test = nixosTests.lidarr;
  };

  meta = with lib; {
    description = "Usenet/BitTorrent music downloader";
    homepage = "https://lidarr.audio/";
    license = licenses.gpl3;
    maintainers = [ maintainers.etu ];
    mainProgram = "Lidarr";
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
  };
}
