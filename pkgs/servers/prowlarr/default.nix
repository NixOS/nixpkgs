{ lib, stdenv, fetchurl, mono, libmediainfo, sqlite, curl, makeWrapper, icu, dotnet-runtime, openssl, nixosTests, zlib }:

let
  pname = "prowlarr";

  unsupported = throw "Unsupported system ${stdenv.hostPlatform.system} for ${pname}";

  os =
    if stdenv.hostPlatform.isDarwin then
      "osx"
    else if stdenv.hostPlatform.isLinux then
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
    aarch64-darwin = "sha256-Okp/+glgeIKzHIcW/9AJAmBEcXPm7ANM23iU/Q4jhf8=";
    aarch64-linux = "sha256-x0hQ/EZGM8XjIqpPGMzxTsL7oUg4YMvc/xNfvmU/sJE=";
    x86_64-darwin = "sha256-Y7N8flvk3HpaSYjg6RJlCfN6eMsM8AuqIJ+oef85+8s=";
    x86_64-linux = "sha256-Egp+U/I9i1PQc/MruGRaOpJtDQUQAyRmu4nC71e8fWM=";
  }.${stdenv.hostPlatform.system} or unsupported;

in stdenv.mkDerivation rec {
  inherit pname;
  version = "1.25.4.4818";

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
    description = "Indexer manager/proxy built on the popular arr .net/reactjs base stack";
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
