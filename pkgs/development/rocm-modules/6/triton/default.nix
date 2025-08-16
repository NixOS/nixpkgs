{
  triton-no-cuda,
  rocmPackages,
  fetchFromGitHub,
}:
(triton-no-cuda.override (_old: {
  inherit rocmPackages;
  rocmSupport = true;
  stdenv = rocmPackages.llvm.rocmClangStdenv;
  llvm = rocmPackages.triton-llvm;
})).overridePythonAttrs
  (old: {
    doCheck = false;
    stdenv = rocmPackages.llvm.rocmClangStdenv;
    version = "v3.3.1";
    src = fetchFromGitHub {
      owner = "triton-lang";
      repo = "triton";
      rev = "v3.3.1";
      hash = "sha256-XLw7s5K0j4mfIvNMumlHkUpklSzVSTRyfGazZ4lLpn0=";
    };
    buildInputs = old.buildInputs ++ [
      rocmPackages.clr
    ];
    dontStrip = true;
    env = old.env // {
      CXXFLAGS = "-O3 -I${rocmPackages.clr}/include -I/build/source/third_party/triton/third_party/nvidia/backend/include";
      TRITON_OFFLINE_BUILD = 1;
    };
    patches = [ ];
    postPatch = ''
      # remove any downloads
      mkdir -p python/triton/tools/extra
      substituteInPlace python/setup.py \
        --replace-fail "[get_json_package_info()]" "[]" \
        --replace-fail "[get_llvm_package_info()]" "[]" \
        --replace-fail 'packages += ["triton/profiler"]' "pass" \
        --replace-fail "curr_version.group(1) != version" "False"
      # Don't fetch googletest
      substituteInPlace cmake/AddTritonUnitTest.cmake \
        --replace-fail 'include(''${PROJECT_SOURCE_DIR}/unittest/googletest.cmake)' "" \
        --replace-fail "include(GoogleTest)" "find_package(GTest REQUIRED)"
      substituteInPlace third_party/amd/backend/compiler.py \
        --replace-fail '"/opt/rocm/llvm/bin/ld.lld"' "os.environ['ROCM_PATH']"' + "/llvm/bin/ld.lld"'
    '';
  })
