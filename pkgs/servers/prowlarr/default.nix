{ lib, stdenv, fetchurl, mono, libmediainfo, sqlite, curl, makeWrapper, icu, dotnet-runtime, openssl, nixosTests, zlib }:

let
  pname = "prowlarr";

  unsupported = throw "Unsupported system ${stdenv.hostPlatform.system} for ${pname}";

  os =
    if stdenv.isDarwin then
      "osx"
    else if stdenv.isLinux then
      "linux"
    else
      unsupported;

  arch = {
    aarch64-darwin = "arm64";
    aarch64-linux = "arm64";
    x86_64-darwin = "x64";
    x86_64-linux = "x64";
  }.${stdenv.hostPlatform.system} or unsupported;

  hash = {
    aarch64-darwin = "sha256-qe+NdHbbAuKevb3ExiLOQRGJiyEGn2tV+lqLvbjDh8Q=";
    aarch64-linux = "sha256-1VylS5hXSHzHZCoscEQrjJwc6Z1/W3YXt2/CRc72TTA=";
    x86_64-darwin = "sha256-y3nw8I8JqsNaRwGcqS8/b5xTd34nk1xJGpMBewxGFcI=";
    x86_64-linux = "sha256-ARtixZAR4tlAJry6maYWiZiYNQl7dGVAlhvcCJGxXBs=";
  }.${stdenv.hostPlatform.system} or unsupported;

in stdenv.mkDerivation rec {
  inherit pname;
  version = "1.11.4.4173";

  src = fetchurl {
    url = "https://github.com/Prowlarr/Prowlarr/releases/download/v${version}/Prowlarr.master.${version}.${os}-core-${arch}.tar.gz";
    inherit hash;
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/${pname}-${version}}
    cp -r * $out/share/${pname}-${version}/.

    makeWrapper "${dotnet-runtime}/bin/dotnet" $out/bin/Prowlarr \
      --add-flags "$out/share/${pname}-${version}/Prowlarr.dll" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [
        curl sqlite libmediainfo mono openssl icu zlib ]}

    runHook postInstall
  '';

  passthru = {
    updateScript = ./update.sh;
    tests.smoke-test = nixosTests.prowlarr;
  };

  meta = with lib; {
    description = "An indexer manager/proxy built on the popular arr .net/reactjs base stack";
    homepage = "https://wiki.servarr.com/prowlarr";
    changelog = "https://github.com/Prowlarr/Prowlarr/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ jdreaver ];
    mainProgram = "Prowlarr";
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
  };
}
