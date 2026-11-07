{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
  ipsw,
  versionCheckHook,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "metal-toolchain";
  version = "32023.921";

  decryptionKey = "BZmjitxr92cS+2KO6/I6/UU7o5BSVa8AitWhz8spV8Y=";

  src = fetchurl {
    url = "https://updates.cdn-apple.com/MobileAssets2026/mobileassets/022-22694/A83C2B89-364B-4954-A45C-B86E3193F828/com_apple_MobileAsset_MetalToolchain/E0AAC6EC-858D-41B2-91C3-3E653FC184CD.aar";
    hash = "sha256-EuROgEfKis5q8/920oAOTEWy4kXxXCT+60dXQA7p7wk=";
  };

  nativeBuildInputs = [
    ipsw
    _7zz
  ];

  unpackPhase = ''
    runHook preUnpack

    ipsw ota extract --key-val '${finalAttrs.decryptionKey}' --output . --pattern 'AssetData/Restore/.*\.dmg$' --confirm "$src"
    dmg=( */AssetData/Restore/*.dmg )

    unpackFile "''${dmg[0]}"

    runHook postUnpack
  '';

  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Library/Developer/Toolchains
    mv Metal.xctoolchain $out/Library/Developer/Toolchains/

    toolchain=$out/Library/Developer/Toolchains/Metal.xctoolchain
    ln -s $toolchain/usr/bin $out/bin
    ln -s $toolchain/usr/share $out/share

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    updateScript = ./update.sh;
  };

  meta = {
    description = "Apple's Metal compiler toolchain (metal, metallib)";
    homepage = "https://developer.apple.com/metal/tools/";
    license = lib.licenses.unfree;
    platforms = lib.platforms.darwin;
    mainProgram = "metal";
    maintainers = [
      lib.maintainers.DimitarNestorov
      lib.maintainers.maxbrunet
    ];
    hydraPlatforms = [ ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
