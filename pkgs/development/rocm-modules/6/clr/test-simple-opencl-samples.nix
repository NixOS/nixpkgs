{
  lib,
  stdenv,
  makeImpureTest,
  fetchFromGitHub,
  clr,
  cmake,
  pkg-config,
  opencl-headers,
  ocl-icd,
}:

let
  examples = stdenv.mkDerivation {
    pname = "simple-opencl-samples";
    version = "2025-09-29";

    src = fetchFromGitHub {
      owner = "bashbaug";
      repo = "SimpleOpenCLSamples";
      rev = "d58373658308d2f8a10c969fb5e5aa8e3b78ec15";
      hash = "sha256-7EA8R2IJYjPg0m0StCVmEh/mbWQvJ0zLSGjbx7ql++k=";
    };

    nativeBuildInputs = [
      cmake
      pkg-config
    ];

    buildInputs = [
      opencl-headers
      ocl-icd
    ];

    patches = [
      ./simple-opencl-samples-system-deps.patch
    ];

    cmakeFlags = [
      (lib.cmakeFeature "OpenCL_INCLUDE_DIR" "${lib.getInclude opencl-headers}/include")
      (lib.cmakeFeature "OpenCL_LIBRARY" "${lib.getLib ocl-icd}/lib/libOpenCL.so")
      (lib.cmakeBool "SAMPLES_ENABLE_EXCEPTIONS" true)
    ];

    # Samples install to $out/Release instead of CMAKE_INSTALL_BINDIR for some reason
    postInstall = ''
      if [ -d $out/Release ]; then
        mkdir -p $out/bin
        mv $out/Release/* $out/bin/
        rmdir $out/Release
      fi
    '';

    meta = with lib; {
      description = "Simple, self-contained OpenCL samples";
      homepage = "https://github.com/bashbaug/SimpleOpenCLSamples";
      license = licenses.mit;
      platforms = platforms.linux;
      teams = [ teams.rocm ];
    };
  };

in
makeImpureTest {
  name = "simple-opencl-samples";
  testedPackage = "rocmPackages_6.clr";

  sandboxPaths = [
    "/sys"
    "/dev/dri"
    "/dev/kfd"
  ];

  nativeBuildInputs = [ examples ];

  OCL_ICD_VENDORS = "${clr.icd}/etc/OpenCL/vendors";
  testScript = ''
    set -euo pipefail
    export AMD_LOG_LEVEL=2
    echo "OCL_ICD_VENDORS=$OCL_ICD_VENDORS"

    cd ${examples}/bin

    (set -x
    # Basic enumeration and queries
    ./enumopencl
    ./enumopenclpp
    ./extendeddevicequeries
    ./newqueries
    ./loaderinfo

    # Buffer operations
    ./copybuffer
    ./copybufferkernel

    # Kernel compilation tests
    ./kernelfromfile
    ./ndrangekernelfromfile

    # Shared Virtual Memory tests
    ./svmqueries
    ./fgsvmhelloworld
    ./cgsvmhelloworld

    # Atomic operations
    ./floatatomics

    # Queue experiments
    ./enumqueuefamilies
    ./queueexperiments

    # Actual compute workloads
    ./julia
    ./mandelbrot
    )

    echo "=== OpenCL tests completed successfully ==="
  '';

  meta = with lib; {
    description = "Test that OpenCL works with ROCm";
    teams = [ teams.rocm ];
  };
}
