# One Tensile shard per GPU architecture. With separate architectures and lazy
# loading, librocblas.so opens lib/rocblas/library/<gfx>/ at runtime, so the
# shards join by directory merge. Other layouts use ./base.nix directly.
{
  lib,
  clr,
  rocblas_base,
  ...
}@args:

let
  base = rocblas_base.override (
    builtins.removeAttrs args [
      "lib"
      "clr"
      "rocblas_base"
    ]
  );
  inherit (base.passthru)
    buildTensile
    tensileSepArch
    tensileLazyLib
    gpuTargets
    ;
  archList = gpuTargets;
  headArch = lib.head archList;
  tailArchs = lib.drop 1 archList;
  shardTensile = buildTensile && tensileSepArch && tensileLazyLib && lib.length archList > 1;

  # One architecture's lazy Tensile library; everything else is dropped.
  mkTensileShard =
    arch:
    (base.override {
      gpuTargets = [ arch ];
      buildTests = false;
      buildBenchmarks = false;
    }).overrideAttrs
      (old: {
        pname = "rocblas-tensile-${arch}";
        meta = (unbreak old).meta;
        outputs = [ "out" ];
        doCheck = false;
        postInstall = (old.postInstall or "") + ''
          keep="$(mktemp -d)"
          cp -r "$out/lib/rocblas/library" "$keep/library"
          rm -rf "$out"/*
          mkdir -p "$out/lib/rocblas"
          mv "$keep/library" "$out/lib/rocblas/library"
          rm -rf "$keep"
        '';
      });

  tensileShards = map mkTensileShard tailArchs;

  # The base is hidden from Hydra; the configured public builds are usable.
  unbreak = old: {
    meta = old.meta // {
      broken = false;
    };
  };
in

# Other Tensile layouts cannot be merged by copying architecture directories.
if !shardTensile then
  base.overrideAttrs unbreak
else
  (base.override {
    gpuTargets = [ headArch ];
  }).overrideAttrs
    (old: {
      pname = "rocblas${clr.gpuArchSuffix}";
      meta = (unbreak old).meta;

      inherit tensileShards;
      disallowedReferences = tensileShards;

      # Merge the shard directories, then strip the shard store path that Tensile
      # embeds in one code object's ELF metadata per architecture. It is not
      # load-bearing (the unsplit build embeds its own $out in the same place),
      # and remove-references-to keeps the ELF layout. disallowedReferences
      # keeps the private shards out of consumers' closures.
      postInstall = (old.postInstall or "") + ''
        for shard in $tensileShards; do
          cp -r --no-preserve=mode "$shard/lib/rocblas/library/"* "$out/lib/rocblas/library/"
        done
        for shard in $tensileShards; do
          find "$out/lib/rocblas/library" -type f -exec remove-references-to -t "$shard" {} +
        done
      '';

      passthru = (old.passthru or { }) // {
        amdgpu_targets = lib.concatStringsSep ";" archList;
        inherit tensileShards;
      };
    })
