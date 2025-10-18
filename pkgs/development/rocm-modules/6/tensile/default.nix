{
  lib,
  fetchFromGitHub,
  fetchpatch,
  rocmUpdateScript,
  buildPythonPackage,
  pytestCheckHook,
  setuptools,
  distro,
  pyyaml,
  msgpack,
  pandas,
  joblib,
  filelock,
  clr,
  rich,
}:

buildPythonPackage rec {
  pname = "tensile";
  # Using a specific commit which has compression support from after the 6.4 release
  # Without compression packages are too large for hydra
  version = "6.4-unstable-2025-06-12";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "Tensile";
    rev = "1ce87a9fe73610ffb962082f0a882360cd39b103";
    hash = "sha256-qIuoIbmridy1HQVV10qPTzbccuxNJPsOvePaQQnClZc=";
  };

  # TODO: It should be possible to run asm caps test ONCE for all supported arches
  # We currently disable the test because it's slow and runs each time tensile launches
  postPatch = ''
    substituteInPlace Tensile/Common.py \
      --replace-fail 'if globalParameters["AssemblerPath"] is not None:' "if False:"
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
    distro
    rich
  ];

  patches = [
    ./tensile-solutionstructs-perf-fix.diff
    ./tensile-create-library-dont-copy-twice.diff
    (fetchpatch {
      # [PATCH] Extend Tensile HIP ISA compatibility
      hash = "sha256-d+fVf/vz+sxGqJ96vuxe0jRMgbC5K6j5FQ5SJ1e3Sl8=";
      url = "https://github.com/GZGavinZhao/Tensile/commit/855cb15839849addb0816a6dde45772034a3e41f.patch";
    })
  ];

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
