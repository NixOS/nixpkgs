{
  stdenv,
  python,
  src,
  socketPatch,
  torch,
}:

stdenv.mkDerivation {
  name = "torch-symmetric-memory-socket-name-test";
  src = "${src}/torch/csrc/distributed/c10d/symm_mem";
  patches = [ socketPatch ];
  patchFlags = [ "-p6" ];
  nativeBuildInputs = [ python ];
  dontConfigure = true;
  buildPhase = ''
    runHook preBuild
    python ${./symm-mem-socket-name.py} \
      --source CUDASymmetricMemoryUtils.cpp --cxx "$CXX" \
      --include ${torch.dev}/include --lib ${torch.lib}/lib \
      --output "$TMPDIR/results"
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    cp "$TMPDIR/results/results.json" "$out/"
    runHook postInstall
  '';
}
