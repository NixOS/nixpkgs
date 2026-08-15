{
  lib,
  requireFile,
}:

let
  requireMetalToolchain =
    release: sha256:
    let
      version = release;

      toolchain = requireFile rec {
        name = "Metal.xctoolchain";
        hashMode = "recursive";
        inherit sha256;
        message = ''
          Unfortunately, we cannot download ${name} automatically.
          The Metal toolchain is distributed as an Xcode component — there is no direct download URL.
          Please download it yourself by running the following commands:

          1. Download Xcode_${release}_Apple_silicon.xip from Apple Developer:
             https://developer.apple.com/services-account/download?path=/Developer_Tools/Xcode_${release}/Xcode_${release}_Apple_silicon.xip

          2. Extract and set DEVELOPER_DIR:
             open -W Xcode_${release}_Apple_silicon.xip
             export DEVELOPER_DIR="$(pwd)/Xcode.app/Contents/Developer"

          3. Download the Metal toolchain component:
             xcodebuild -downloadComponent metalToolchain -exportPath /tmp/MetalExport/

          4. Mount the DMG and add the toolchain to the Nix store:
             hdiutil attach -readonly -nobrowse -mountpoint /tmp/mt /tmp/MetalExport/MetalToolchain-*.exportedBundle/Restore/*.dmg
             nix-store --add-fixed --recursive sha256 /tmp/mt/Metal.xctoolchain
             hdiutil detach /tmp/mt

          5. Clean up:
             rm -rf Xcode.app /tmp/MetalExport

          Note: Xcode is only needed temporarily to export the Metal toolchain.
          Once added to the Nix store, Xcode is no longer required.
        '';
      };

      meta = {
        description = "Apple's Metal compiler toolchain (metal, metallib)";
        homepage = "https://developer.apple.com/xcode/";
        license = lib.licenses.unfree;
        platforms = lib.platforms.darwin;
        maintainers = [ lib.maintainers.maxbrunet ];
        hydraPlatforms = [ ];
        sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
      };

    in
    toolchain.overrideAttrs (
      oldAttrs:
      oldAttrs
      // {
        pname = "metal-toolchain";
        inherit version;
        inherit meta;
      }
    );

in
lib.makeExtensible (self: {
  inherit requireMetalToolchain;

  # Metal toolchain bundled with Xcode 26.6 (Apple Silicon)
  metal-toolchain_26_6 = requireMetalToolchain "26.6" "sha256-7/nR1TOnc3PtQxdjrL+3Trd29sHBhtwCyGkm1ao2IA4=";

  # Default: latest version
  metal-toolchain = self.metal-toolchain_26_6;
})
