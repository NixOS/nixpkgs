{ lib, stdenv, fetchurl, makeWrapper, patchelf, openssl, libunwind, zlib, krb5, icu, nixosTests }:

let
  os = if stdenv.isDarwin then "osx" else "linux";
  arch = {
    x86_64-linux = "x64";
    aarch64-linux = "arm64";
    x86_64-darwin = "x64";
  }."${stdenv.hostPlatform.system}" or (throw
    "Unsupported system: ${stdenv.hostPlatform.system}");

  hash = {
    x64-linux_hash = "sha256-Cuvz9Mhwpg8RIaiSXib+QW00DM66qPRQulrchRL2BSk=";
    arm64-linux_hash = "sha256-uyVwa73moHWMZScNNSOU17lALuK3PC/cvTZPJ9qg7JQ=";
    x64-osx_hash = "sha256-FGXLsfEuCW94D786LJ/wvA9TakOn5sG2M1rDXPQicYw=";
  }."${arch}-${os}_hash";

  rpath = lib.makeLibraryPath [
    stdenv.cc.cc openssl libunwind zlib krb5 icu
  ];

  dynamicLinker = stdenv.cc.bintools.dynamicLinker;

in stdenv.mkDerivation rec {
  pname = "ombi";
  version = "4.0.1292";

  sourceRoot = ".";

  src = fetchurl {
    url = "https://github.com/Ombi-app/Ombi/releases/download/v${version}/${os}-${arch}.tar.gz";
    sha256 = hash;
  };

  buildInputs = [ makeWrapper patchelf ];

  installPhase = ''
    mkdir -p $out/{bin,share/${pname}-${version}}
    cp -r * $out/share/${pname}-${version}

    makeWrapper $out/share/${pname}-${version}/Ombi $out/bin/Ombi \
      --run "cd $out/share/${pname}-${version}"
  '';

  dontPatchELF = true;
  postFixup = ''
    patchelf --set-interpreter "${dynamicLinker}" \
      --set-rpath "$ORIGIN:${rpath}" $out/share/${pname}-${version}/Ombi

    find $out -type f -name "*.so" -exec \
      patchelf --set-rpath '$ORIGIN:${rpath}' {} ';'
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
