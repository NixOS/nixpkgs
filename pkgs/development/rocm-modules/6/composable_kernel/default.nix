{
  lib,
  clr,
  composable_kernel_base,
}:

let
  parts = {
    _mha = {
      # mha takes ~3hrs on 64 cores on an EPYC milan system at ~2.5GHz
      # big-parallel builders are one gen newer and clocked ~30% higher but only 24 cores
      # Should be <10h timeout but might be cutting it close
      # TODO: work out how to split this into smaller chunks instead of all 3k mha instances together
      # mha_0,1,2, search ninja target file for the individual instances, split by the index?
      # TODO: can we prune the generated instances down to only what in practice are used with popular models
      # when using flash-attention + MHA kernels?
      targets = [
        "device_mha_instance"
      ];
      requiredSystemFeatures = [ "big-parallel" ];
      extraCmakeFlags = [ "-DHIP_CLANG_NUM_PARALLEL_JOBS=2" ];
    };
    gemm_multiply_multiply = {
      targets = [
        "device_gemm_multiply_multiply_instance"
      ];
      requiredSystemFeatures = [ "big-parallel" ];
      extraCmakeFlags = [ "-DHIP_CLANG_NUM_PARALLEL_JOBS=2" ];
    };
    grouped_conv = {
      targets = [
        "device_grouped_conv1d_bwd_weight_instance"
        "device_grouped_conv2d_bwd_data_instance"
        "device_grouped_conv2d_bwd_weight_instance"
        "device_grouped_conv1d_fwd_instance"
        "device_grouped_conv2d_fwd_instance"
        "device_grouped_conv2d_fwd_dynamic_op_instance"
      ];
    };
    grouped_conv_bwd_3d = {
      targets = [
        "device_grouped_conv3d_bwd_data_instance"
        "device_grouped_conv3d_bwd_data_bilinear_instance"
        "device_grouped_conv3d_bwd_data_scale_instance"
        "device_grouped_conv3d_bwd_weight_instance"
        "device_grouped_conv3d_bwd_weight_bilinear_instance"
        "device_grouped_conv3d_bwd_weight_scale_instance"
      ];
    };
    grouped_conv_fwd_3d = {
      targets = [
        "device_grouped_conv3d_fwd_instance"
        "device_grouped_conv3d_fwd_bilinear_instance"
        "device_grouped_conv3d_fwd_convinvscale_instance"
        "device_grouped_conv3d_fwd_convscale_instance"
        "device_grouped_conv3d_fwd_convscale_add_instance"
        "device_grouped_conv3d_fwd_convscale_relu_instance"
        "device_grouped_conv3d_fwd_dynamic_op_instance"
        "device_grouped_conv3d_fwd_scale_instance"
        "device_grouped_conv3d_fwd_scaleadd_ab_instance"
        "device_grouped_conv3d_fwd_scaleadd_scaleadd_relu_instance"
      ];
    };
    batched_gemm = {
      targets = [
        "device_batched_gemm_instance"
        "device_batched_gemm_add_relu_gemm_add_instance"
        "device_batched_gemm_bias_permute_instance"
        "device_batched_gemm_gemm_instance"
        "device_batched_gemm_reduce_instance"
        "device_batched_gemm_softmax_gemm_instance"
        "device_batched_gemm_softmax_gemm_permute_instance"
        "device_grouped_gemm_instance"
        "device_grouped_gemm_bias_instance"
        "device_grouped_gemm_fastgelu_instance"
        "device_grouped_gemm_fixed_nk_instance"
        "device_grouped_gemm_fixed_nk_multi_abd_instance"
        "device_grouped_gemm_tile_loop_instance"
      ];
    };
    gemm_universal = {
      targets = [
        "device_gemm_universal_instance"
        "device_gemm_universal_batched_instance"
        "device_gemm_universal_reduce_instance"
        "device_gemm_universal_streamk_instance"
      ];
      requiredSystemFeatures = [ "big-parallel" ];
      extraCmakeFlags = [ "-DHIP_CLANG_NUM_PARALLEL_JOBS=2" ];
    };
    gemm_other = {
      targets = [
        "device_gemm_instance"
        "device_gemm_ab_scale_instance"
        "device_gemm_add_instance"
        "device_gemm_add_add_fastgelu_instance"
        "device_gemm_add_fastgelu_instance"
        "device_gemm_add_multiply_instance"
        "device_gemm_add_relu_instance"
        "device_gemm_add_relu_add_layernorm_instance"
        "device_gemm_add_silu_instance"
        "device_gemm_bias_add_reduce_instance"
        "device_gemm_bilinear_instance"
        "device_gemm_fastgelu_instance"
        "device_gemm_multi_abd_instance"
        "device_gemm_multiply_add_instance"
        "device_gemm_reduce_instance"
        "device_gemm_splitk_instance"
        "device_gemm_streamk_instance"
      ];
    };
    conv = {
      targets = [
        "device_conv1d_bwd_data_instance"
        "device_conv2d_bwd_data_instance"
        "device_conv2d_fwd_instance"
        "device_conv2d_fwd_bias_relu_instance"
        "device_conv2d_fwd_bias_relu_add_instance"
        "device_conv3d_bwd_data_instance"
      ];
    };
    pool = {
      targets = [
        "device_avg_pool2d_bwd_instance"
        "device_avg_pool3d_bwd_instance"
        "device_pool2d_fwd_instance"
        "device_pool3d_fwd_instance"
        "device_max_pool_bwd_instance"
      ];
    };
    other1 = {
      targets = [
        "device_batchnorm_instance"
        "device_contraction_bilinear_instance"
        "device_contraction_scale_instance"
        "device_elementwise_instance"
        "device_elementwise_normalization_instance"
        "device_normalization_bwd_data_instance"
        "device_normalization_bwd_gamma_beta_instance"
        "device_normalization_fwd_instance"
      ];
    };
    other2 = {
      targets = [
        "device_column_to_image_instance"
        "device_image_to_column_instance"
        "device_permute_scale_instance"
        "device_quantization_instance"
        "device_reduce_instance"
        "device_softmax_instance"
        "device_transpose_instance"
      ];
    };
  };
  tensorOpBuilder =
    {
      part,
      targets,
      extraCmakeFlags ? [ ],
      requiredSystemFeatures ? [ ],
    }:
    composable_kernel_base.overrideAttrs (old: {
      inherit requiredSystemFeatures;
      pname = "composable_kernel${clr.gpuArchSuffix}-${part}";
      makeTargets = targets;
      preBuild = ''
        echo "Building ${part}"
        makeFlagsArray+=($makeTargets)
        substituteInPlace Makefile \
          --replace-fail '.NOTPARALLEL:' ""
      '';

      # Compile parallelism adjusted based on available RAM
      # Never uses less than NIX_BUILD_CORES/4, never uses more than NIX_BUILD_CORES
      # CK uses an unusually high amount of memory per core in the build step
      # Nix/nixpkgs doesn't really have any infra to tell it that this build is unusually memory hungry
      # So, bodge. Otherwise you end up having to build all of ROCm with a low core limit when
      # it's only this package that has trouble.
      preConfigure =
        old.preConfigure or ""
        + ''
          MEM_GB_TOTAL=$(awk '/MemTotal/ { printf "%d \n", $2/1024/1024 }' /proc/meminfo)
          MEM_GB_AVAILABLE=$(awk '/MemAvailable/ { printf "%d \n", $2/1024/1024 }' /proc/meminfo)
          APPX_GB=$((MEM_GB_AVAILABLE > MEM_GB_TOTAL ? MEM_GB_TOTAL : MEM_GB_AVAILABLE))
          MAX_CORES=$((1 + APPX_GB/3))
          MAX_CORES=$((MAX_CORES < NIX_BUILD_CORES/3 ? NIX_BUILD_CORES/3 : MAX_CORES))
          export NIX_BUILD_CORES="$((NIX_BUILD_CORES > MAX_CORES ? MAX_CORES : NIX_BUILD_CORES))"
          echo "Picked new core limit NIX_BUILD_CORES=$NIX_BUILD_CORES based on available mem: $APPX_GB GB"
          cmakeFlagsArray+=(
            "-DCK_PARALLEL_COMPILE_JOBS=$NIX_BUILD_CORES"
          )
        '';
      cmakeFlags = old.cmakeFlags ++ extraCmakeFlags;
      # Early exit after build phase with success, skips fixups etc
      # Will get copied back into /build of the final CK
      postBuild = ''
        find . -name "*.o" -type f | while read -r file; do
          mkdir -p "$out/$(dirname "$file")"
          cp --reflink=auto "$file" "$out/$file"
        done
        exit 0
      '';
      meta = old.meta // {
        broken = false;
      };
    });
  composable_kernel_parts = builtins.mapAttrs (
    part: targets: tensorOpBuilder (targets // { inherit part; })
  ) parts;
in

composable_kernel_base.overrideAttrs (
  finalAttrs: old: {
    pname = "composable_kernel${clr.gpuArchSuffix}";
    parts_dirs = builtins.attrValues composable_kernel_parts;
    disallowedReferences = builtins.attrValues composable_kernel_parts;
    preBuild = ''
      for dir in $parts_dirs; do
        find "$dir" -type f -name "*.o" | while read -r file; do
          # Extract the relative path by removing the output directory prefix
          rel_path="''${file#"$dir/"}"

          # Create parent directory if it doesn't exist
          mkdir -p "$(dirname "$rel_path")"

          # Copy the file back to its original location, give it a future timestamp
          # so make treats it as up to date
          cp --reflink=auto --no-preserve=all "$file" "$rel_path"
          touch -d "now +10 hours" "$rel_path"
        done
      done
    '';
    passthru = old.passthru // {
      parts = composable_kernel_parts;
    };
    meta = old.meta // {
      # Builds which don't don't target any gfx9 cause cmake errors in dependent projects
      broken = !finalAttrs.passthru.anyGfx9Target;
    };
  }
)
