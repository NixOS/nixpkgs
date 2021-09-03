{ lib, stdenv, fetchurl, makeWrapper, autoPatchelfHook, fixDarwinDylibNames, zlib, krb5, openssl, icu, nixosTests }:

let
  os = if stdenv.isDarwin then "osx" else "linux";
  arch = {
    x86_64-linux = "x64";
    aarch64-linux = "arm64";
    x86_64-darwin = "x64";
  }."${stdenv.hostPlatform.system}" or (throw
    "Unsupported system: ${stdenv.hostPlatform.system}");

  hash = {
    x64-linux_hash = "sha256-4kvcBRMMH4AnTKSES5Cpst/omTRXVRq1V1y/z5njKJI=";
    arm64-linux_hash = "sha256-NLsf0ldvlKSrHJyAXv5Ar2zIetoga6iZPOGTxFOqoQQ=";
    x64-osx_hash = "sha256-tjvGuShz/fv3qUknFVKJ+tE/bVtIyPZ7dr4JfTEcDJY=";
  }."${arch}-${os}_hash";

in stdenv.mkDerivation rec {
  pname = "ombi";
  version = "4.0.1468";

  sourceRoot = ".";

  src = fetchurl {
    url = "https://github.com/Ombi-app/Ombi/releases/download/v${version}/${os}-${arch}.tar.gz";
    sha256 = hash;
  };

  nativeBuildInputs = [ makeWrapper autoPatchelfHook ]
    ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  propagatedBuildInputs = [ stdenv.cc.cc zlib krb5 ];

  installPhase = ''
    mkdir -p $out/{bin,share/${pname}-${version}}
    cp -r * $out/share/${pname}-${version}

    makeWrapper $out/share/${pname}-${version}/Ombi $out/bin/Ombi \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ openssl icu ]} \
      --run "cd $out/share/${pname}-${version}"
  '';

  passthru = {
    updateScript = ./update.sh;
    tests.smoke-test = nixosTests.ombi;
  };

  meta = with lib; {
    description = "Self-hosted web application that automatically gives your shared Plex or Emby users the ability to request content by themselves";
    homepage = "https://ombi.io/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ woky ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
  };
}
