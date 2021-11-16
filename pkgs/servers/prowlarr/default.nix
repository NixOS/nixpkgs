{ lib, stdenv, fetchurl, mono, libmediainfo, sqlite, curl, makeWrapper, icu, dotnetCorePackages, openssl, nixosTests }:

let
  os =
    if stdenv.isDarwin then
      "osx"
    else if stdenv.isLinux then
      "linux"
    else
      throw "Not supported on ${stdenv.hostPlatform.system}.";

  arch = {
    x86_64-linux = "x64";
    aarch64-linux = "arm64";
    x86_64-darwin = "x64";
  }."${stdenv.hostPlatform.system}" or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  hash = {
    x64-linux_hash = "sha256-S3ktqBapIi6YIjDOIMziCzecS86hR2LIUey3SLNuWgg=";
    arm64-linux_hash = "sha256-lxPglw3whyMQ+v7GpKMygxqINDoczKmh7KpGAuzuQwM=";
    x64-osx_hash = "sha256-EUg3eC5QwGgCSi9qAPs6s8wenSXEmLvLHUTlvoLWAtc=";
  }."${arch}-${os}_hash";

in stdenv.mkDerivation rec {
  pname = "prowlarr";
  version = "0.1.2.1060";

  src = fetchurl {
    url = "https://github.com/Prowlarr/Prowlarr/releases/download/v${version}/Prowlarr.develop.${version}.${os}-core-${arch}.tar.gz";
    sha256 = hash;
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/${pname}-${version}}
    cp -r * $out/share/${pname}-${version}/.

    makeWrapper "${dotnetCorePackages.runtime_3_1}/bin/dotnet" $out/bin/Prowlarr \
      --add-flags "$out/share/${pname}-${version}/Prowlarr.dll" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [
        curl sqlite libmediainfo mono openssl icu ]}

    runHook postInstall
  '';

  passthru = {
    updateScript = ./update.sh;
    tests.smoke-test = nixosTests.prowlarr;
  };

  meta = with lib; {
    description = "An indexer manager/proxy built on the popular arr .net/reactjs base stack";
    homepage = "https://wiki.servarr.com/prowlarr";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ jdreaver ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
  };
}
