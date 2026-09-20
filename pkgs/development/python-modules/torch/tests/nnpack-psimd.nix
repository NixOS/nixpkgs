{
  stdenv,
  python3,
  src,
  nnpackPatch,
}:

stdenv.mkDerivation {
  name = "torch-nnpack-psimd-test";
  # Test the actual vendored sources without compiling or copying all of Torch.
  srcs = [
    "${src}/third_party/NNPACK"
    "${src}/third_party/psimd"
  ];
  sourceRoot = ".";
  patches = [ nnpackPatch ];
  patchFlags = [ "-p2" ];

  nativeBuildInputs = [ python3 ];
  dontConfigure = true;
  buildPhase = ''
    runHook preBuild
    python ${./.}/nnpack-psimd.py \
      --source-root "$PWD" --output "$TMPDIR/results" \
      --cc "$CC" --check-input-pointers
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    cp "$TMPDIR/results/"*.json "$TMPDIR/results/"*.log "$out/"
    runHook postInstall
  '';
}
