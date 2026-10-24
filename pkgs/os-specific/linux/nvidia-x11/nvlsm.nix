version: sha256:
{
  lib,
  cudaPackages_12_9,
  fetchurl,
  patchelf,
}:

# cudaPackages may not contain nvlsm and must match the datacenter version.
cudaPackages_12_9.nvlsm.overrideAttrs (oldAttrs: {
  inherit version;

  src = oldAttrs.src.overrideAttrs (_: {
    inherit version;
    src = fetchurl {
      url = "https://developer.download.nvidia.com/compute/nvidia-driver/redist/nvlsm/linux-x86_64/nvlsm-linux-x86_64-${version}-archive.tar.xz";
      hash = sha256;
    };
  });

  # nvlsm loads the grpc plugin through dlopen("libgrpc_mgr.so").
  # Preserve the plugin's directory in the binary RUNPATH.
  postFixup = (oldAttrs.postFixup or "") + ''
    test -f "$out/lib/libgrpc_mgr.so"
    ${lib.getExe patchelf} --add-rpath "$out/lib" "$out/bin/nvlsm"
  '';
})
