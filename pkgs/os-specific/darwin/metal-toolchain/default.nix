{
  lib,
  stdenvNoCC,
  requireFile,
}:

let
  requireMetalToolchain =
    {
      release,
      sha256,
      buildVersion ? null,
    }:
    let
      xip = "Xcode_" + release + ".xip";
      version = lib.removeSuffix "_Universal" (lib.removeSuffix "_Apple_silicon" release);
      downloadCommand =
        "xcodebuild -downloadComponent metalToolchain -exportPath /tmp/MetalExport/"
        + lib.optionalString (buildVersion != null) " -buildVersion ${buildVersion}";
      exportedBundle = "/tmp/MetalExport/MetalToolchain-${
        if buildVersion != null then buildVersion else "*"
      }.exportedBundle";

      toolchain = requireFile rec {
        name = "Metal.xctoolchain";
        hashMode = "recursive";
        inherit sha256;
        message = ''
          Unfortunately, we cannot download ${name} automatically.
          The Metal toolchain is distributed as an Xcode component — there is no direct download URL.
          Please download it yourself by running the following commands:

          1. Download ${xip} from Apple Developer:
             https://developer.apple.com/services-account/download?path=/Developer_Tools/Xcode_${version}/${xip}

          2. Extract and set DEVELOPER_DIR:
             open -W ${xip}
             export DEVELOPER_DIR="$(pwd)/Xcode.app/Contents/Developer"

          3. Download the Metal toolchain component:
             ${downloadCommand}

          4. Mount the DMG and add the toolchain to the Nix store:
             hdiutil attach -readonly -nobrowse -mountpoint /tmp/mt ${exportedBundle}/Restore/*.dmg
             nix-store --add-fixed --recursive sha256 /tmp/mt/Metal.xctoolchain
             hdiutil detach /tmp/mt

          5. Clean up:
             rm -rf Xcode.app /tmp/MetalExport

          Note: Xcode is only needed temporarily to export the Metal toolchain.
          Once added to the Nix store, Xcode is no longer required.
          If Xcode is already installed, steps 1-2 can be skipped: any
          xcodebuild can download the component with -buildVersion ${
            if buildVersion != null then buildVersion else "<build version>"
          }

          If the hash does not match, you exported a different Metal toolchain.
          Build your own with:
          pkgs.darwin.requireMetalToolchain {
            release = "<your Xcode version>";
            buildVersion = "<printed by xcodebuild after the download>";
            sha256 = "<your export's hash>";
          }
          The hash is printed by: nix hash path --sri /tmp/mt/Metal.xctoolchain
          Please also open a PR to nixpkgs adding an entry with your
          version, build version and hash.
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
        mainProgram = "metal";
        maintainers = [
          lib.maintainers.DimitarNestorov
          lib.maintainers.maxbrunet
        ];
        hydraPlatforms = [ ];
        sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
      };
    };

in
lib.makeExtensible (self: {
  inherit requireMetalToolchain;

  # Metal toolchain 32023.883 (Xcode 26.6, Apple Silicon)
  metal-toolchain_26_6 = self.requireMetalToolchain {
    release = "26.6_Apple_silicon";
    sha256 = "sha256-7/nR1TOnc3PtQxdjrL+3Trd29sHBhtwCyGkm1ao2IA4=";
    buildVersion = "17F109";
  };

  # Default: latest version
  metal-toolchain = self.metal-toolchain_26_6;
})
