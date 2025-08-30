{
  lib,
  config,
  stdenvNoCC,
  xwin,
  testers,
  llvmPackages,
}:
let
  version = (builtins.fromJSON (builtins.readFile ./manifest.json)).info.buildVersion;

  hashes = (builtins.fromJSON (builtins.readFile ./hashes.json));

  host = stdenvNoCC.hostPlatform;
  arch =
    if host.isx86_64 then
      "x86_64"
    else if host.isAarch64 then
      "aarch64"
    else if host.isx86_32 then
      "x86"
    else if host.isAarch32 then
      "aarch"
    else
      throw "Unsupported system";
in
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit version;
  pname = "msvc-sdk";
  dontUnpack = true;

  strictDeps = true;
  nativeBuildInputs = [ xwin ];

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash =
    if !config.microsoftVisualStudioLicenseAccepted then
      throw ''
        Microsoft Software License Terms are not accepted with config.microsoftVisualStudioLicenseAccepted.
        Please read https://visualstudio.microsoft.com/license-terms/mt644918/ and if you agree, change your
        config to indicate so.
      ''
    else
      hashes.${arch};

  __structuredAttrs = true;
  xwinArgs = [
    "--accept-license"
    "--cache-dir=xwin-out"
    "--manifest=${./manifest.json}"
    "--arch=${arch}"
    "splat"
    "--preserve-ms-arch-notation"
  ];

  buildPhase = ''
    runHook preBuild

    xwin "''${xwinArgs[@]}"
    mkdir "$out"
    mv xwin-out/splat/* "$out"

    runHook postBuild
  '';

  dontFixup = true;
  dontInstall = true;

  passthru = {
    updateScript = ./update.nu;
    tests = {
      hello-world = testers.runCommand {
        name = "hello-msvc";

        nativeBuildInputs = [
          llvmPackages.clang-unwrapped
          llvmPackages.bintools-unwrapped
        ];

        script = ''
          set -euo pipefail

          cat > hello.c <<- EOF
          #include <stdio.h>

          int main(int argc, char* argv[]) {
              printf("Hello world!\n");
              return 0;
          }
          EOF

          clang-cl --target=x86_64-pc-windows-msvc -fuse-ld=lld \
              /vctoolsdir ${finalAttrs.finalPackage}/crt \
              /winsdkdir ${finalAttrs.finalPackage}/sdk \
              ./hello.c -v

          if test ! -f hello.exe; then
            echo "hello.exe not found!"
            exit 1
          else
            touch $out
          fi
        '';
      };
    };
  };

  meta = {
    description = "MSVC SDK and Windows CRT for cross compiling";
    homepage = "https://developer.microsoft.com/en-us/windows/downloads/windows-sdk/";
    maintainers = [ lib.maintainers.RossSmyth ];
    license = {
      deprecated = false;
      fullName = "Microsoft Software License Terms";
      shortName = "msvc";
      spdxId = "unknown";
      free = false;
      url = "https://www.visualstudio.com/license-terms/mt644918/";
    };
    platforms = lib.platforms.all;
    # The arm32 manifest is missing critical pieces.
    broken = stdenvNoCC.hostPlatform.isAarch32;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    teams = [ lib.teams.windows ];
  };
})
