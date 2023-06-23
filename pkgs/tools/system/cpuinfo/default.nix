{
  fetchFromGitHub,
  lib,
  stdenv,
  # nativeBuildInputs
  cmake,
  ninja,
  # checkInputs
  gbenchmark,
  gtest,
  # Configuration options
  buildTools ? false,
  buildSharedLibs ? true,
}: let
  setBuildSharedLibrary = bool:
    if bool
    then "shared"
    else "static";
  setBool = bool:
    if bool
    then "ON"
    else "OFF";
in
  stdenv.mkDerivation (finalAttrs: {
    strictDeps = true;
    pname = "cpuinfo";
    version = finalAttrs.src.rev;
    outputs = [
      "out"
      "lib"
    ];
    src = fetchFromGitHub {
      owner = "pytorch";
      repo = finalAttrs.pname;
      rev = "512e9d0258212d6759729330b445fa41f4fa0a49";
      hash = "sha256-/wwEKX7ILhTpU6cFtpN5Gq4jIA8XaKnj82BM2FMtALQ=";
    };
    prePatch =
      # Skip the tests that fail on NixOS
      ''
        substituteInPlace test/init.cc \
          --replace \
            'TEST(CORE, known_uarch) {' \
            'TEST(CORE, DISABLED_known_uarch) {'
      '';

    nativeBuildInputs = [
      cmake
      ninja
    ];

    cmakeFlags = [
      "-DUSE_SYSTEM_LIBS:BOOL=ON"
      "-DCPUINFO_BUILD_BENCHMARKS:BOOL=${setBool finalAttrs.doCheck}"
      "-DCPUINFO_BUILD_MOCK_TESTS:BOOL=${setBool finalAttrs.doCheck}"
      "-DCPUINFO_BUILD_TOOLS:BOOL=${setBool buildTools}"
      "-DCPUINFO_BUILD_UNIT_TESTS:BOOL=${setBool finalAttrs.doCheck}"
      "-DCPUINFO_LIBRARY_TYPE:STRING=${setBuildSharedLibrary buildSharedLibs}"
      "-DCPUINFO_RUNTIME_TYPE:STRING=${setBuildSharedLibrary buildSharedLibs}"
    ];

    doCheck = true;
    checkInputs = [
      gbenchmark
      gtest
    ];

    meta = with lib; {
      description = "CPU INFOrmation library";
      homepage = "https://github.com/pytorch/cpuinfo";
      license = licenses.bsd2;
      maintainers = with maintainers; [connorbaker];
      platforms = platforms.all;
    };
  })
