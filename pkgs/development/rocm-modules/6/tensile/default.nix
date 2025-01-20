{
  lib,
  stdenv,
  fetchFromGitHub,
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

  # TODO: run asm caps test !ONCE! for all supported arches as part of this build
  # We currently disable the test because it's slow and runs each time tensile launches (multiple times per build)

  postPatch = ''
    ${lib.optionalString (!isTensileLite) ''
      if grep -F .SafeLoader Tensile/LibraryIO.py; then
        substituteInPlace Tensile/LibraryIO.py \
          --replace-fail "yaml.SafeLoader" "yaml.CSafeLoader"
      fi
      substituteInPlace Tensile/Common.py \
        --replace-fail 'globalParameters["PrintLevel"] = 1' 'globalParameters["PrintLevel"] = 2'
    ''}
      #find Tensile -name '*.py' -exec sed -i 's/yaml.SafeLoader/yaml.CSafeLoader/gI' {} \;
      #find Tensile -name '*.py' -exec sed -Ei 's/yaml.load\(([a-zA-Z0-9_]{0,20})\)/yaml.load(\1, yaml.CSafeLoader)/gI' {} \;

      #substituteInPlace Tensile/Common.py \
      #  --replace-fail 'globalParameters["PrintLevel"] = 1' 'globalParameters["PrintLevel"] = 2'
      # --replace-fail "defaultGlobalParameters = deepcopy(globalParameters)" "globalParameters['SupportedISA'] = [(9,0,0),(9,0,8),(9,0,10),(9,4,2),(10,1,0),(10,3,0),(11,0,0),(11,0,1),(11,0,2)]; defaultGlobalParameters = deepcopy(globalParameters)"
    ${lib.optionalString altParallelImpl ''
      substituteInPlace requirements.txt \
        --replace-fail joblib ""
      rm Tensile/Parallel.py
      cp ${./Parallel.py} Tensile/Parallel.py
    ''}
    ${lib.optionalString (!isTensileLite) ''
      # See TODO above about asm caps test
      substituteInPlace Tensile/Common.py \
        --replace-fail 'if globalParameters["AssemblerPath"] is not None:' "if False:"
      # substituteInPlace Tensile/Source/CMakeLists.txt \
      #   --replace-fail \
      #   'set(TENSILE_GPU_ARCHS gfx803 gfx900 gfx906:xnack- gfx908:xnack- gfx90a:xnack- gfx1010 gfx1011 gfx1012 gfx1030 gfx1031 gfx1032 gfx1034 gfx1035 gfx1100 gfx1101 gfx1102 CACHE STRING "GPU architectures")' \
      #   'set(TENSILE_GPU_ARCHS gfx900 gfx908 gfx90a gfx1010 gfx1030 gfx1100 gfx1101 gfx1102)'
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
    ++ (lib.optional isTensileLite ./tensile-create-library-dont-copy-twice.diff)
    ++ (lib.optional isTensileLite ./gen_assembly-venv-err-handling.diff)
    ++ (lib.optional isTensileLite ./log-fallback.diff);

  doCheck = false; # Too many errors, not sure how to set this up properly

  nativeCheckInputs = [
    pytestCheckHook
    filelock
    rocminfo
  ];

  env = {
    ROCM_PATH = rocminfo;
  };

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
