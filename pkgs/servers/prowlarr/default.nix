{ lib, stdenv, fetchurl, mono, libmediainfo, sqlite, curl, makeWrapper, icu, dotnet-runtime, openssl, nixosTests, zlib }:

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
    x64-linux_hash = "sha256-0JeZaHaAJ0Z+wcEPGA8yidiKsU/lxEgC6BGpFEzjO0A=";
    arm64-linux_hash = "sha256-/N8SY0JS3yX2MARb7MN68CWEZQ8mIXM5zmg96r8hVsw=";
    x64-osx_hash = "sha256-kcD6ATOGYJULk6g+v4uISDtnzr0c1y2BntIt3MWUR0Q=";
  }."${arch}-${os}_hash";

in stdenv.mkDerivation rec {
  pname = "prowlarr";
  version = "1.1.2.2453";

  src = fetchurl {
    url = "https://github.com/Prowlarr/Prowlarr/releases/download/v${version}/Prowlarr.develop.${version}.${os}-core-${arch}.tar.gz";
    sha256 = hash;
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
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ jdreaver ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
  };
}
