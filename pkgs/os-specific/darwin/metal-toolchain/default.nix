{
  lib,
  stdenvNoCC,
  requireFile,
}:

let
  # Release entry attribute name: the Metal toolchain version with dots
  # replaced by underscores (e.g. "32023.883" -> "metal-toolchain_32023_883").
  attrNameOf = version: "metal-toolchain_" + lib.replaceStrings [ "." ] [ "_" ] version;

  # The Metal toolchain is versioned independently of Xcode: one toolchain
  # version has one content hash and can be exported from different Xcode
  # releases. The package version is therefore the toolchain's own, while
  # `xcodeRelease` is only used for the retrieval instructions and can be
  # overridden with any Xcode release known to export the same toolchain.
  requireMetalToolchain =
    {
      version,
      sha256,
      xcodeRelease ? "26.6_Apple_silicon",
    }:
    let
      xip = "Xcode_" + xcodeRelease + ".xip";
      xcodeVersion = lib.removeSuffix "_Universal" (lib.removeSuffix "_Apple_silicon" xcodeRelease);
      attrName = attrNameOf version;

      toolchain = requireFile rec {
        name = "Metal.xctoolchain";
        hashMode = "recursive";
        inherit sha256;
        message = ''
          Unfortunately, we cannot download ${name} automatically.
          The Metal toolchain is distributed as an Xcode component — there is no direct download URL.
          Please download it yourself by running the following commands:

          1. Download ${xip} from Apple Developer:
             https://developer.apple.com/services-account/download?path=/Developer_Tools/Xcode_${xcodeVersion}/${xip}

          2. Extract and set DEVELOPER_DIR:
             open -W ${xip}
             export DEVELOPER_DIR="$(pwd)/Xcode.app/Contents/Developer"

          3. Download the Metal toolchain component:
             xcodebuild -downloadComponent metalToolchain -exportPath /tmp/MetalExport/

          4. Mount the DMG and check the Metal toolchain version — it must be ${version}:
             hdiutil attach -readonly -nobrowse -mountpoint /tmp/mt /tmp/MetalExport/MetalToolchain-*.exportedBundle/Restore/*.dmg
             plutil -extract Identifier raw /tmp/mt/Metal.xctoolchain/ToolchainInfo.plist
             # expected: com.apple.dt.toolchain.Metal.${version}

             If a different version is reported, try
             pkgs.darwin.metal-toolchain_<version> (dots replaced by
             underscores, e.g. ${attrName}) — if it does not exist yet, build
             your own with:
             pkgs.darwin.requireMetalToolchain {
               version = "<your version>";
               sha256 = "<your export's hash>";
             }
             The hash is printed by: nix hash path --sri /tmp/mt/Metal.xctoolchain
             Please also open a PR to nixpkgs adding an entry with your
             version and hash.

          5. Add the toolchain to the Nix store:
             nix-store --add-fixed --recursive sha256 /tmp/mt/Metal.xctoolchain
             hdiutil detach /tmp/mt

          6. Clean up:
             rm -rf Xcode.app /tmp/MetalExport

          Note: Xcode is only needed temporarily to export the Metal toolchain.
          Once added to the Nix store, Xcode is no longer required.
        '';
      };
    in
    stdenvNoCC.mkDerivation {
      pname = "metal-toolchain";
      inherit version;

      dontUnpack = true;
      dontBuild = true;

      installPhase = ''
        runHook preInstall

        mkdir -p $out/Library/Developer/Toolchains
        ln -s ${toolchain}/usr/bin $out/bin
        ln -s ${toolchain}/usr/share $out/share
        ln -s ${toolchain} $out/Library/Developer/Toolchains/Metal.xctoolchain

        runHook postInstall
      '';

      meta = {
        description = "Apple's Metal compiler toolchain (metal, metallib)";
        homepage = "https://developer.apple.com/metal/tools/";
        license = lib.licenses.unfree;
        platforms = lib.platforms.darwin;
        maintainers = [ lib.maintainers.maxbrunet ];
        hydraPlatforms = [ ];
        sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
      };
    };

in
lib.makeExtensible (self: {
  inherit requireMetalToolchain;

  metal-toolchain_32023_883 = self.requireMetalToolchain {
    version = "32023.883";
    sha256 = "sha256-7/nR1TOnc3PtQxdjrL+3Trd29sHBhtwCyGkm1ao2IA4=";
  };

  metal-toolchain =
    self."${attrNameOf (
      if (stdenvNoCC.targetPlatform ? metalToolchainVer) then
        stdenvNoCC.targetPlatform.metalToolchainVer
      else
        "32023.883"
    )}";
})
