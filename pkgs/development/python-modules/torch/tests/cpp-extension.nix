{
  runCommandWith,
  stdenvNoCC,
  python,
  writableTmpDirAsHomeHook,
}:
let
  pythonEnv = python.withPackages (ps: [ ps.torch ]);
in
# No compiler or ninja in the environment: torch.utils.cpp_extension must find them on its own
runCommandWith
  {
    name = "torch-cpp-extension-check";
    stdenv = stdenvNoCC;
    derivationArgs.nativeBuildInputs = [ writableTmpDirAsHomeHook ];
  }
  ''
    unset CC CXX
    export TORCH_EXTENSIONS_DIR="$TMPDIR/torch_extensions"

    ${pythonEnv.interpreter} - <<'EOF'
    import torch
    from torch.utils.cpp_extension import load_inline

    ext = load_inline(
        name="add_one",
        cpp_sources="torch::Tensor add_one(torch::Tensor x) { return x + 1; }",
        functions=["add_one"],
        verbose=True,
    )
    assert torch.equal(ext.add_one(torch.zeros(3)), torch.ones(3))
    EOF

    touch $out
  ''
