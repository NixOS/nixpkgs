{ lib
, stdenv
, makeImpureTest
, fetchFromGitHub
, clr
, cmake
, pkg-config
, glew
, libglut
, opencl-headers
, ocl-icd
}:

let

  examples = stdenv.mkDerivation {
    pname = "amd-app-samples";
    version = "2018-06-10";

    src = fetchFromGitHub {
      owner = "OpenCL";
      repo = "AMD_APP_samples";
      rev = "54da6ca465634e78fc51fc25edf5840467ee2411";
      hash = "sha256-qARQpUiYsamHbko/I1gPZE9pUGJ+3396Vk2n7ERSftA=";
    };

    nativeBuildInputs = [ cmake pkg-config ];

    buildInputs = [ glew libglut opencl-headers ocl-icd ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      # Example path is bin/x86_64/Release/cl/Reduction/Reduction
      cp -r bin/*/*/*/*/* $out/bin/

      runHook postInstall
    '';

    cmakeFlags = [ "-DBUILD_CPP_CL=OFF" ];

    meta = with lib; {
      description = "Samples from the AMD APP SDK (with OpenCRun support)";
      homepage    = "https://github.com/OpenCL/AMD_APP_samples";
      license     = licenses.bsd2;
      platforms   = platforms.linux;
      maintainers = lib.teams.rocm.members;
    };
  };

in
makeImpureTest {
  name = "opencl-example";
  testedPackage = "rocmPackages_6.clr";

  sandboxPaths = [ "/sys" "/dev/dri" "/dev/kfd" ];

  nativeBuildInputs = [ examples ];

  OCL_ICD_VENDORS = "${clr.icd}/etc/OpenCL/vendors";

  testScript = ''
    # Examples load resources from current directory
    cd ${examples}/bin
    echo OCL_ICD_VENDORS=$OCL_ICD_VENDORS
    pwd

    HelloWorld | grep HelloWorld
  '';

  meta = with lib; {
    maintainers = teams.rocm.members;
  };
}
