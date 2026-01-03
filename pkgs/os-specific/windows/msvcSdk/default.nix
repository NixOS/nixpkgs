{
  lib,
  stdenvNoCC,
  xwin,
  testers,
  llvmPackages,
  callPackage,
}:
let
  version = (builtins.fromJSON (builtins.readFile ./manifest.json)).info.buildVersion;

  hashes = (builtins.fromJSON (builtins.readFile ./hashes.json));

  fetchWinSdk = callPackage ./fetchWinSdk.nix { };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit version;
  pname = "win-sdk";

  src = fetchWinSdk {
    manifest = ./manifest.json;
    hash = hashes.${finalAttrs.src.arch};
  };

  strictDeps = true;
  nativeBuildInputs = [
    xwin
  ];

  __structuredAttrs = true;
  xwinArgs = [
    "--accept-license"
    "--cache-dir=."
    "--manifest=${./manifest.json}"
    "--arch=${finalAttrs.src.arch}"
    "splat"
    "--preserve-ms-arch-notation"
  ];

  installPhase = ''
    runHook preInstall

    xwin "''${xwinArgs[@]}"

    mkdir -p "$out"
    cp -r splat/* "$out"

    runHook postInstall
  '';

  dontFixup = true;

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
