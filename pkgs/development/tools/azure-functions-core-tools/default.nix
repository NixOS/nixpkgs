{ stdenv
, lib
, config
, fetchurl
, unzip
, makeWrapper
, icu
, libunwind
, curl
, zlib
, libuuid
, dotnetbuildhelpers
, dotnetCorePackages
, openssl
}:

stdenv.mkDerivation rec {
  pname = "azure-functions-core-tools";
  version = "4.0.4736";

  src = fetchurl {
    url = "https://github.com/Azure/${pname}/releases/download/${version}/Azure.Functions.Cli.linux-x64.${version}.zip";
    sha256 = "sha256-9b93nqvaMUjMfmB8WoVuQBHOEfFwkq94cAOfdTGD6WA=";
  };

  nativeBuildInputs = [
    unzip
    makeWrapper
    dotnetbuildhelpers
    icu
    libunwind
    curl
    zlib
    dotnetCorePackages.sdk_3_1
  ];

  libPath = lib.makeLibraryPath [
    libunwind
    libuuid
    stdenv.cc.cc
    curl
    zlib
    icu
    openssl
  ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -prd * $out/bin
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}" "$out/bin/func"
    chmod +x $out/bin/func $out/bin/gozip
    find $out/bin -type f -name "*.so" -exec patchelf --set-rpath "${libPath}" {} \;
    wrapProgram "$out/bin/func" --prefix LD_LIBRARY_PATH : ${libPath}
  '';
  dontStrip = true; # Causes rpath patching to break if not set

  meta = with lib; {
    homepage = "https://github.com/Azure/azure-functions-core-tools";
    description = "Command line tools for Azure Functions";
    sourceProvenance = with sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    license = licenses.mit;
    maintainers = with maintainers; [ jshcmpbll ];
    platforms = platforms.linux;
  };
}
