{
  lib,
  stdenv,
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
  rocminfo,
  writeText,
  zstd,
  rich,
  isTensileLite ? false,
  altParallelImpl ? false,
}:

buildPythonPackage rec {
  pname = if isTensileLite then "tensilelite" else "tensile";
  version = "6.2.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "Tensile";
    # rev = "rocm-${version}";
    # hash = "sha256-E9UtdCLPUzRoNMzjD+A00faMx9eOxH5ouU04WNl2vjM=";
    rev = "1752af518190500891a865379a4569b8abf6ba01"; # with code object compression!
    hash = "sha256-Wvz4PVs//3Ox7ykZHpjPzOVwlyATyc+MmVVenfTzWK4=";
  };

  # TODO: run asm caps test ONCE for all supported arches as part of this build
  # We currently disable the test because it's slow and runs each time tensile launches (multiple times per build)

  postPatch = ''
    ${lib.optionalString (!isTensileLite) ''
      if grep -F .SafeLoader Tensile/LibraryIO.py; then
        substituteInPlace Tensile/LibraryIO.py \
          --replace-fail "yaml.SafeLoader" "yaml.CSafeLoader"
      fi
      substituteInPlace Tensile/Common.py \
        --replace-fail 'globalParameters["PrintLevel"] = 1' 'globalParameters["PrintLevel"] = 2'
      # See TODO above about asm caps test
      substituteInPlace Tensile/Common.py \
        --replace-fail 'if globalParameters["AssemblerPath"] is not None:' "if False:"
    ''}
    ${lib.optionalString altParallelImpl ''
      substituteInPlace requirements.txt \
        --replace-fail joblib ""
      rm Tensile/Parallel.py
      cp ${./Parallel.py} Tensile/Parallel.py
    ''}
      find . -type f -iname "*.sh" -exec chmod +x {} \;
      patchShebangs Tensile
  '';

  buildInputs = [ setuptools ];

  propagatedBuildInputs =
    [
      pyyaml
      msgpack
      pandas
      # FIXME: zsd optional only on if msgpack-zstd on
      zstd # propagated because this *produces source that needs to link to zlib* when invoked in downstream builds
    ]
    ++ lib.optional (!altParallelImpl) joblib
    ++ lib.optionals (!isTensileLite) [
      rich
    ]
    ++ lib.optionals isTensileLite [
      simplejson
      ujson
      orjson
    ];

  patches =
    (lib.optional (!isTensileLite) ./tensile-6.3.0-create-library-dont-copy-twice.diff)
    ++ (lib.optional (!isTensileLite) (fetchpatch {
      # [PATCH] Extend Tensile HIP ISA compatibility
      sha256 = "sha256-d+fVf/vz+sxGqJ96vuxe0jRMgbC5K6j5FQ5SJ1e3Sl8=";
      url = "https://github.com/GZGavinZhao/Tensile/commit/855cb15839849addb0816a6dde45772034a3e41f.patch";
    }))
    ++ (lib.optional isTensileLite ./tensile-create-library-dont-copy-twice.diff)
    ++ (lib.optional isTensileLite ./gen_assembly-venv-err-handling.diff)
    ++ (lib.optional isTensileLite ./log-fallback.diff)
    ++ (lib.optional isTensileLite ./tensile-compression.diff);

  doCheck = false; # Too many errors, not sure how to set this up properly

  nativeCheckInputs = [
    pytestCheckHook
    filelock
    rocminfo
  ];

  env = {
    ROCM_PATH = rocminfo;
  };

  # TODO: remove this workaround once https://github.com/NixOS/nixpkgs/pull/323869
  # does not cause issues anymore, or at least replace it with a better workaround
  setupHook = writeText "setup-hook" ''
    export TENSILE_ROCM_ASSEMBLER_PATH="${stdenv.cc.cc}/bin/clang++";
  '';

  pythonImportsCheck = [ "Tensile" ];

  passthru.updateScript = rocmUpdateScript {
    name = pname;
    inherit (src) owner;
    inherit (src) repo;
  };

  meta = with lib; {
    description = "GEMMs and tensor contractions";
    homepage = "https://github.com/ROCm/Tensile";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
  };
}
