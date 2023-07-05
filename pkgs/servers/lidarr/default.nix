{ lib, stdenv, fetchurl, mono, libmediainfo, sqlite, curl, chromaprint, makeWrapper, icu, dotnet-runtime, openssl, nixosTests }:

let
  os = if stdenv.isDarwin then "osx" else "linux";
  arch = {
    x86_64-linux = "x64";
    aarch64-linux = "arm64";
    x86_64-darwin = "x64";
  }."${stdenv.hostPlatform.system}" or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  hash = {
    x64-linux_hash = "sha256-fYfqkv3o9aly2bgY5iiZETs4LZfrbJGWd7XeRP4nTu0=";
    arm64-linux_hash = "sha256-ENdQQnjxNFyVYnTdxZuaSO4oJ7sd4Oa9TLs8xu93p5g=";
    x64-osx_hash = "sha256-LwzwMsqq8RDBiQbKtBVKJPhh4woQTpVr+T0K8ii6kG8=";
  }."${arch}-${os}_hash";
in stdenv.mkDerivation rec {
  pname = "lidarr";
  version = "1.2.6.3313";

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
        curl sqlite libmediainfo icu  openssl ]}

    runHook postInstall
  '';


  passthru = {
    updateScript = ./update.sh;
    tests.smoke-test = nixosTests.lidarr;
  };

  meta = with lib; {
    description = "A Usenet/BitTorrent music downloader";
    homepage = "https://lidarr.audio/";
    license = licenses.gpl3;
    maintainers = [ maintainers.etu ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
  };
}
