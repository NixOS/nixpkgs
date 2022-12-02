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
  version = "4.0.4785";

  src =
    if stdenv.isLinux then
      fetchurl {
        url = "https://github.com/Azure/${pname}/releases/download/${version}/Azure.Functions.Cli.linux-x64.${version}.zip";
        sha256 = "sha256-SWvbPEslwhYNd2fTQJWy1+823o1vJR/roPstgelSfnQ=";
      }
    else
      fetchurl {
        url = "https://github.com/Azure/${pname}/releases/download/${version}/Azure.Functions.Cli.osx-x64.${version}.zip";
        sha256 = "sha256-m06XeUHVDCxo7sfK4eF1oM6IuaVET9jr/xSO9qzpxSU=";
      }
    ;

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
    cp -prd . $out/bin/azure-functions-core-tools
    chmod +x $out/bin/azure-functions-core-tools/{func,gozip}
  '' + lib.optionalString stdenv.isLinux ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}" "$out/bin/azure-functions-core-tools/func"
    find $out/bin/azure-functions-core-tools -type f -name "*.so" -exec patchelf --set-rpath "${libPath}" {} \;
    wrapProgram "$out/bin/azure-functions-core-tools/func" --prefix LD_LIBRARY_PATH : ${libPath}
  '' + ''
    ln -s $out/bin/{azure-functions-core-tools,}/func
    ln -s $out/bin/{azure-functions-core-tools,}/gozip
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
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
