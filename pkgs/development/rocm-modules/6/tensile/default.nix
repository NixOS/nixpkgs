{
  lib,
  fetchFromGitHub,
  fetchpatch,
  rocmUpdateScript,
  buildPythonPackage,
  pytestCheckHook,
  setuptools,
  pyyaml,
  msgpack,
  simplejson,
  ujson,
  orjson,
  pandas,
  joblib,
  filelock,
  clr,
  rich,
  isTensileLite ? false,
}:

buildPythonPackage rec {
  pname = if isTensileLite then "tensilelite" else "tensile";
  # Using a specific commit which has code object compression support from after the 6.3 release
  # Without compression packages are too large for hydra
  version = "6.3-unstable-2024-12-10";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "Tensile";
    rev = "1752af518190500891a865379a4569b8abf6ba01";
    hash = "sha256-Wvz4PVs//3Ox7ykZHpjPzOVwlyATyc+MmVVenfTzWK4=";
  };

  # TODO: It should be possible to run asm caps test ONCE for all supported arches
  # We currently disable the test because it's slow and runs each time tensile launches

  postPatch =
    lib.optionalString (!isTensileLite) ''
      if grep -F .SafeLoader Tensile/LibraryIO.py; then
        substituteInPlace Tensile/LibraryIO.py \
          --replace-fail "yaml.SafeLoader" "yaml.CSafeLoader"
      fi
      # See TODO above about asm caps test
      substituteInPlace Tensile/Common.py \
        --replace-fail 'if globalParameters["AssemblerPath"] is not None:' "if False:"
    ''
    + ''
      # Add an assert that the fallback 9,0,0 is supported before setting the kernel to it
      # If it's not detected as supported we have an issue with compiler paths or the compiler is broken
      # and it's better to stop immediately
      substituteInPlace Tensile/KernelWriter.py \
        --replace-fail '= (9,0,0)' '= (9,0,0);assert(globalParameters["AsmCaps"][(9,0,0)]["SupportedISA"])'
      find . -type f -iname "*.sh" -exec chmod +x {} \;
      patchShebangs Tensile
    '';

  buildInputs = [ setuptools ];

  propagatedBuildInputs = [
    pyyaml
    msgpack
    pandas
    joblib
  ]
  ++ lib.optionals (!isTensileLite) [
    rich
  ]
  ++ lib.optionals isTensileLite [
    simplejson
    ujson
    orjson
  ];

  patches =
    lib.optional (!isTensileLite) ./tensile-solutionstructs-perf-fix.diff
    ++ lib.optional (!isTensileLite) ./tensile-create-library-dont-copy-twice.diff
    ++ lib.optional (!isTensileLite) (fetchpatch {
      # [PATCH] Extend Tensile HIP ISA compatibility
      sha256 = "sha256-d+fVf/vz+sxGqJ96vuxe0jRMgbC5K6j5FQ5SJ1e3Sl8=";
      url = "https://github.com/GZGavinZhao/Tensile/commit/855cb15839849addb0816a6dde45772034a3e41f.patch";
    })
    ++ lib.optional isTensileLite ./tensilelite-create-library-dont-copy-twice.diff
    ++ lib.optional isTensileLite ./tensilelite-gen_assembly-venv-err-handling.diff
    ++ lib.optional isTensileLite ./tensilelite-compression.diff;

  doCheck = false; # Too many errors, not sure how to set this up properly

  nativeCheckInputs = [
    pytestCheckHook
    filelock
    clr
  ];

  env.ROCM_PATH = "${clr}";

  pythonImportsCheck = [ "Tensile" ];

  passthru.updateScript = rocmUpdateScript {
    name = pname;
    inherit (src) owner repo;
  };

  meta = with lib; {
    description = "GEMMs and tensor contractions";
    homepage = "https://github.com/ROCm/Tensile";
    license = with licenses; [ mit ];
    teams = [ teams.rocm ];
    platforms = platforms.linux;
  };
}
