{ lib, stdenv, fetchurl, mono, libmediainfo, sqlite, curl, makeWrapper, icu, dotnetCorePackages, openssl, nixosTests }:

let
  os = if stdenv.isDarwin then "osx" else "linux";
  arch = {
    x86_64-linux = "x64";
    aarch64-linux = "arm64";
    x86_64-darwin = "x64";
  }."${stdenv.hostPlatform.system}" or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  hash = {
    x64-linux_hash = "sha256-4jzQ/bax323r4OzWwr9vq+6x0GasBZhRT+i6bDS/RMs=";
    arm64-linux_hash = "sha256-IOFKlqey9biL8wCpbIxMnZZ5Svvrh6KMkNoZ7GBht3M=";
    x64-osx_hash = "sha256-tdyEYY6qXNKjMPW652gtPAhTm/aNyTe+CgZ5aA9k2EM=";
  }."${arch}-${os}_hash";

in stdenv.mkDerivation rec {
  pname = "radarr";
  version = "4.0.5.5981";

  src = fetchurl {
    url = "https://github.com/Radarr/Radarr/releases/download/v${version}/Radarr.master.${version}.${os}-core-${arch}.tar.gz";
    sha256 = hash;
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/${pname}-${version}}
    cp -r * $out/share/${pname}-${version}/.

    makeWrapper "${dotnetCorePackages.runtime_3_1}/bin/dotnet" $out/bin/Radarr \
      --add-flags "$out/share/${pname}-${version}/Radarr.dll" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [
        curl sqlite libmediainfo mono openssl icu ]}

    runHook postInstall
  '';

  passthru = {
    updateScript = ./update.sh;
    tests.smoke-test = nixosTests.radarr;
  };

  meta = with lib; {
    description = "A Usenet/BitTorrent movie downloader";
    homepage = "https://radarr.video/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ edwtjo purcell ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
  };
}
