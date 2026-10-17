# rocBLAS with its Tensile kernel libraries split into one self-contained shard
# per GPU arch, so changing or adding a single arch rebuilds only that arch's
# kernels instead of the whole multi-arch set.
#
# Why this is safe (verified against the ROCm 10 rocm-libraries source and a built
# output):
#   rocBLAS builds Tensile with SEPARATE_ARCHITECTURES + LAZY_LIBRARY_LOADING (both
#   set in base.nix), which emit one self-contained directory per gfx under
#   `lib/rocblas/library/<gfx>/` -- each carrying its own
#   `TensileLibrary_lazy_<gfx>.dat` index plus that arch's `.co`/`.dat`/`.hsaco` code
#   objects, and nothing else. In a shared build the kernels are not linked into
#   librocblas.so: merge_archives.py runs only for `NOT BUILD_SHARED_LIBS`
#   (library/src/CMakeLists.txt:792). At runtime the .so opens
#   `library/<arch>/TensileLibrary_lazy_<arch>.dat` by path (TensileManifest.txt is
#   deliberately excluded; nothing reads a global index), so a .so built for one arch
#   loads any other arch's directory dropped in beside it. The join is therefore a
#   plain per-arch-directory merge: no relink, no shared-index reconcile.
#
# Structure (mirrors composable_kernel's base.nix + default.nix op-shard, but on the
# arch axis, merging data rather than relinking objects):
#   * `mkTensileShard arch` -- the base built with GPU_TARGETS=[<gfx>], keeping only
#     `lib/rocblas/library/<gfx>/`.
#   * the join builds librocblas.so + headers + cmake once (for the head arch) and
#     merges every other arch's shard directory in postInstall.
#   * invariant: consumers see one `rocblas` attr with an identical `$out` layout, and
#     `passthru.amdgpu_targets` is the full arch list, not just the head.
#
# A single-arch scope has no tail archs, so the split is a no-op there and returns the
# un-split base build verbatim (see below). The head arch's kernels are recompiled each
# time the join runs; building only the kernels (cf. CK's makeTargets) would remove
# that cost but is left out here for simplicity.
{
  lib,
  clr,
  rocblas_base,
}:

let
  archList = clr.localGpuTargets or clr.gpuTargets;
  headArch = lib.head archList;
  tailArchs = lib.drop 1 archList;

  # One self-contained per-arch Tensile library shard. Built from the base for a
  # single gfx; everything but `lib/rocblas/library/<arch>/` is dropped so the shard
  # is small and holds only the per-arch data the join merges.
  mkTensileShard =
    arch:
    (rocblas_base.override {
      gpuTargets = [ arch ];
      buildTests = false;
      buildBenchmarks = false;
    }).overrideAttrs
      (old: {
        pname = "rocblas-tensile-${arch}";
        meta = (unbreak old).meta;
        outputs = [ "out" ];
        doCheck = false;
        # Keep ONLY the per-arch Tensile library directory.
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

  # rocblas_base is marked broken so it is never built directly; every build
  # derived from it here clears that.
  unbreak = old: { meta = old.meta // { broken = false; }; };
in

# Single-arch scopes (e.g. rocmPackages.gfx906.*) have no tail archs, so the split is
# a no-op there: return the un-split base build verbatim so its derivation is
# identical to the pre-split one. Sharding only takes effect for multi-arch builds.
if tailArchs == [ ] then
  (rocblas_base.override { gpuTargets = archList; }).overrideAttrs unbreak
else

  # The public rocBLAS: host .so + headers + cmake built once for the head arch, with
  # every other arch's Tensile library merged in. Identical layout + passthru to the
  # un-split build.
  (rocblas_base.override {
    gpuTargets = [ headArch ];
  }).overrideAttrs
    (old: {
      pname = "rocblas${clr.gpuArchSuffix}";
      meta = (unbreak old).meta;

      # Referenced (space-separated store paths) in postInstall; declaring them here
      # makes them build inputs of the join.
      inherit tensileShards;
      disallowedReferences = tensileShards;

      # After the normal (head-arch) install, merge each tail arch's shard dir so
      # lib/rocblas/library/ ends up with a self-contained subdir per requested arch.
      #
      # Then strip the shard store paths that Tensile bakes into a per-arch code
      # object's ELF metadata (empirically one `.co` per arch, e.g.
      # `TensileLibrary_Type_BB_HPA_Contraction_..._gfxNNNN.co`). This reference is
      # NOT load-bearing — the un-split multi-arch build embeds its own `$out` in the
      # same spot as a permitted self-reference and runs fine; the GPU code loader
      # reads the kernel image, never this string. Without the strip the joined output
      # refers to the private per-arch shards (caught by `disallowedReferences` below),
      # which would drag every shard into consumers' closures. `remove-references-to`
      # does an equal-length hash substitution, so the ELF stays byte-aligned and the
      # kernels are unaffected. base.nix already uses it (for `tensile`), so
      # `removeReferencesTo` is on PATH here via the inherited nativeBuildInputs.
      postInstall = (old.postInstall or "") + ''
        for shard in $tensileShards; do
          cp -r --no-preserve=mode "$shard/lib/rocblas/library/"* "$out/lib/rocblas/library/"
        done
        for shard in $tensileShards; do
          find "$out/lib/rocblas/library" -type f -exec remove-references-to -t "$shard" {} +
        done
      '';

      passthru = (old.passthru or { }) // {
        # Consumers must see the FULL arch set, not just the head the .so was built for.
        amdgpu_targets = lib.concatStringsSep ";" archList;
        inherit tensileShards;
      };
    })
