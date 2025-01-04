{
  runCommandLocal,
  composable_kernel_build,
  ck4inductor,
  zstd,
}:
let
  ck = composable_kernel_build;
in
runCommandLocal "unpack-${ck.pname}"
  {
    nativeBuildInputs = [ zstd ];
    inherit (ck) meta;
  }
  ''
    mkdir -p $out
    cp -r --no-preserve=mode ${ck}/* $out
    for zs in $out/lib/libdevice_*_operations.a.zst; do
      zstd -dv --rm "$zs" -o "''${zs/.zst}"
    done
    substituteInPlace $out/lib/cmake/composable_kernel/*.cmake \
      --replace "${ck}" "$out"
    cp -r --no-preserve=mode ${ck4inductor}/* $out/

    if [ ! -e $out/lib/python3.12/site-packages/ck4inductor/library/src/tensor_operation_instance/gpu/gemm_universal ]; then
      echo "Missing gemm_universal at expected path for pytorch CK backend"
      exit 1
    fi
  ''
