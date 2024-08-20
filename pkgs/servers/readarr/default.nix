{ lib, stdenv, fetchurl, libmediainfo, sqlite, curl, makeWrapper, icu, dotnet-runtime, openssl, nixosTests, zlib }:

let
  os = if stdenv.isDarwin then "osx" else "linux";
  arch = {
    x86_64-linux = "x64";
    aarch64-linux = "arm64";
    x86_64-darwin = "x64";
  }."${stdenv.hostPlatform.system}" or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  hash = {
    x64-linux_hash = "sha256-qvq4Ivv9AKIljEwdMMKWjy5vZnZ4LPd0gxUUIHcEP7E=";
    arm64-linux_hash = "sha256-MNJOIDNT+3ZZP7sTnTdiDFG+Q+42dUvEj6pGZ3LLS/4=";
    x64-osx_hash = "sha256-DKPllZhtebuOfYrJVfhxfhPcoXSnozD2VM6+NP3azus=";
  }."${arch}-${os}_hash";
in stdenv.mkDerivation rec {
  pname = "readarr";
  version = "0.3.32.2587";

  src = fetchurl {
    url = "https://github.com/Readarr/Readarr/releases/download/v${version}/Readarr.develop.${version}.${os}-core-${arch}.tar.gz";
    sha256 = hash;
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/${pname}-${version}}
    cp -r * $out/share/${pname}-${version}/.
    makeWrapper "${dotnet-runtime}/bin/dotnet" $out/bin/Readarr \
      --add-flags "$out/share/${pname}-${version}/Readarr.dll" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ curl sqlite libmediainfo icu openssl zlib ]}

    runHook postInstall
  '';


  passthru = {
    updateScript = ./update.sh;
    tests.smoke-test = nixosTests.readarr;
  };

  meta = with lib; {
    description = "Usenet/BitTorrent ebook downloader";
    homepage = "https://readarr.com";
    license = licenses.gpl3;
    maintainers = [ maintainers.jocelynthode ];
    mainProgram = "Readarr";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
  };
}

