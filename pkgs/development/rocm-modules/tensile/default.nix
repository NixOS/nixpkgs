{
  lib,
  fetchpatch,
  fetchRocmMonorepoSource,
  rocmVersion,
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

let
  source = rec {
    repo = "rocm-libraries";
    version = rocmVersion;
    sourceSubdir = "shared/tensile";
    hash = "sha256-E3Q3I583RMl+aQbdIKwGdoIXnzK368h+gvyhMYpOnmQ=";
    src = fetchRocmMonorepoSource {
      inherit
        hash
        repo
        sourceSubdir
        version
        ;
    };
    sourceRoot = "${src.name}/${sourceSubdir}";
    homepage = "https://github.com/ROCm/${repo}/tree/rocm-${version}/${sourceSubdir}";
  };
in
buildPythonPackage {
  pname = "tensile";
  inherit (source) version src sourceRoot;
  pyproject = true;

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
      hash = "sha256-ZHXNYSeLkhhNDaIfdqQm68Pxmh1shUL7mAVmh8/I6Xk=";
      url = "https://github.com/GZGavinZhao/rocm-libraries/commit/1f7135dfc0cdb175c8f0e5eb71b2d24699942873.patch";
      relative = "shared/tensile";
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

  meta = {
    inherit (source) homepage;
    description = "GEMMs and tensor contractions";
    license = with lib.licenses; [ mit ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
}
