{
  _cuda,
  cudaPackages,
  fetchurl,
  lib,
  stdenvNoCC,
}:

let
  cudaMajorVersion = cudaPackages.cudaMajorVersion; # only 12, 13 supported

  # NOTE: The versions used should match the versions Warp requires:
  # https://github.com/NVIDIA/warp/blob/${version}/deps/libmathdx-deps.packman.xml
  # NVIDIA no longer publishes new libmathdx releases for CUDA 12.
  # nix-hash --type sha256 --to-sri $(nix-prefetch-url "https://...")
  releases = {
    "12" = {
      version = "0.3.1";
      hashes = {
        aarch64-linux = "sha256-hm7VbDNncnPxCmUoW3RglUHPiTdFWOJDSsn7XUyd47o=";
        x86_64-linux = "sha256-soL5XwAos5iA5+dxVezQFXAJBShq/Yi9YxByiUCQ+dk=";
      };
    };
    "13" = {
      version = "0.4.1";
      hashes = {
        aarch64-linux = "sha256-JpLDb4AgQX4TYWVIirfF25Q8pKN48ftgQNY0LgfTjVw=";
        x86_64-linux = "sha256-fOCytY3TT0LS2mMcFNl/YzvpcoenSMq1ewVdYRgjB00=";
      };
    };
  };
  release = releases.${cudaMajorVersion} or null;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "libmathdx";
  version = release.version or "unsupported";

  outputs = [
    "out"
    "static"
  ];

  src =
    let
      baseURL = "https://developer.nvidia.com/downloads/compute/cublasdx/redist/cublasdx";
      cudaVersion = "${cudaMajorVersion}.0"; # URL example: ${baseURL}/cuda12/${name}-${version}-cuda12.0.tar.gz
      name = lib.concatStringsSep "-" [
        finalAttrs.pname
        "Linux"
        stdenvNoCC.hostPlatform.parsed.cpu.name
        finalAttrs.version
        "cuda${cudaVersion}"
      ];
    in
    lib.mapNullable (
      hash:
      fetchurl {
        inherit hash name;
        url = "${baseURL}/cuda${cudaMajorVersion}/${name}.tar.gz";
      }
    ) (release.hashes.${stdenvNoCC.hostPlatform.system} or null);

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase =
    let
      extraTarFlags = toString (
        # Starting with 0.4.0, the archive wraps its content in a top-level `libmathdx-linux-<arch>` directory
        lib.optionals (lib.versionAtLeast finalAttrs.version "0.4.0") [
          "--strip-components=1"
        ]
      );
    in
    ''
      runHook preInstall

      mkdir -p "$out"
      tar -xzf "$src" -C "$out" ${extraTarFlags}

      mkdir -p "$static"
      moveToOutput "lib/libmathdx_static.a" "$static"

      runHook postInstall
    '';

  meta = {
    description = "Library used to integrate cuBLASDx and cuFFTDx into Warp";
    homepage = "https://developer.nvidia.com/cublasdx-downloads";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = with lib.licenses; [
      # By downloading and using the software, you agree to fully
      # comply with the terms and conditions of the NVIDIA Software
      # License Agreement.
      lib.licenses.nvidiaMath_sdk_sla

      # Some of the libmathdx routines were written by or derived
      # from code written by Meta Platforms, Inc. and affiliates and
      # are subject to the BSD License.
      bsd3

      # Some of the libmathdx routines were written by or derived from
      # code written by Victor Zverovich and are subject to the following
      # license:
      mit
    ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    maintainers = with lib.maintainers; [ yzx9 ];
  };
})
