{ lib, stdenv, fetchurl, libmediainfo, sqlite, curl, makeWrapper, icu, dotnet-runtime, openssl, nixosTests }:

let
  os = if stdenv.isDarwin then "osx" else "linux";
  arch = {
    x86_64-linux = "x64";
    aarch64-linux = "arm64";
    x86_64-darwin = "x64";
  }."${stdenv.hostPlatform.system}" or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  hash = {
    x64-linux_hash = "sha256-4kCDbmq47wb7OuE5JzHPZ/mM9w6wcupFblJieu5dFxc=";
    arm64-linux_hash = "sha256-Val9dEB4E3dnfeXT2ERwE+VoITSXeA7Lc51dyz1jJyQ=";
    x64-osx_hash = "sha256-LvjAeftlNw5F6YFyhKLW9Fv9UIk6AgnGnxOu6ctmQNg=";
  }."${arch}-${os}_hash";
in stdenv.mkDerivation rec {
  pname = "readarr";
  version = "0.3.20.2452";

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
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ curl sqlite libmediainfo icu openssl ]}

    runHook postInstall
  '';


  passthru = {
    updateScript = ./update.sh;
    tests.smoke-test = nixosTests.readarr;
  };

  meta = with lib; {
    description = "A Usenet/BitTorrent ebook downloader";
    homepage = "https://readarr.com";
    license = licenses.gpl3;
    maintainers = [ maintainers.jocelynthode ];
    mainProgram = "Readarr";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
  };
}

