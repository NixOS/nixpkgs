{
  lib,
  stdenv,
  gcc12Stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  pkg-config,
  cmake,
  ninja,
  git,
  doxygen,
  sphinx,
  lit,
  libxml2,
  libxcrypt,
  libedit,
  libffi,
  mpfr,
  zlib,
  ncurses,
  python3Packages,
  buildDocs ? true,
  buildMan ? true,
  buildTests ? true,
  targetName ? "llvm",
  targetDir ? "llvm",
  targetProjects ? [ ],
  targetRuntimes ? [ ],
  llvmTargetsToBuild ? [ "NATIVE" ], # "NATIVE" resolves into x86 or aarch64 depending on stdenv
  extraPatches ? [ ],
  extraNativeBuildInputs ? [ ],
  extraBuildInputs ? [ ],
  extraCMakeFlags ? [ ],
  extraPostPatch ? "",
  checkTargets ? [
    (lib.optionalString buildTests (if targetDir == "runtimes" then "check-runtimes" else "check-all"))
  ],
  extraPostInstall ? "",
  hardeningDisable ? [ ],
  requiredSystemFeatures ? [ ],
  extraLicenses ? [ ],
  isBroken ? false,
}:

let
  stdenv' = stdenv;
in
let
  stdenv =
    if stdenv'.cc.cc.isGNU or false && lib.versionAtLeast stdenv'.cc.cc.version "13.0" then
      gcc12Stdenv
    else
      stdenv';
in

let
  llvmNativeTarget =
    if stdenv.hostPlatform.isx86_64 then
      "X86"
    else if stdenv.hostPlatform.isAarch64 then
      "AArch64"
    else
      throw "Unsupported ROCm LLVM platform";
  inferNativeTarget = t: if t == "NATIVE" then llvmNativeTarget else t;
  llvmTargetsToBuild' = [ "AMDGPU" ] ++ builtins.map inferNativeTarget llvmTargetsToBuild;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "rocm-llvm-${targetName}";
  version = "6.0.2";

  outputs =
    [
      "out"
    ]
    ++ lib.optionals buildDocs [
      "doc"
    ]
    ++ lib.optionals buildMan [
      "man"
      "info" # Avoid `attribute 'info' missing` when using with wrapCC
    ];

  patches = extraPatches;

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "llvm-project";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-uGxalrwMNCOSqSFVrYUBi3ijkMEFFTrzFImmvZKQf6I=";
  };

  nativeBuildInputs =
    [
      pkg-config
      cmake
      ninja
      git
      (python3Packages.python.withPackages (p: [ p.setuptools ]))
    ]
    ++ lib.optionals (buildDocs || buildMan) [
      doxygen
      sphinx
      python3Packages.recommonmark
    ]
    ++ lib.optionals (buildTests && !finalAttrs.passthru.isLLVM) [
      lit
    ]
    ++ extraNativeBuildInputs;

  buildInputs = [
    libxml2
    libxcrypt
    libedit
    libffi
    mpfr
  ] ++ extraBuildInputs;

  propagatedBuildInputs = lib.optionals finalAttrs.passthru.isLLVM [
    zlib
    ncurses
  ];

  sourceRoot = "${finalAttrs.src.name}/${targetDir}";

  cmakeFlags =
    [
      "-DLLVM_TARGETS_TO_BUILD=${builtins.concatStringsSep ";" llvmTargetsToBuild'}"
    ]
    ++ lib.optionals (finalAttrs.passthru.isLLVM && targetProjects != [ ]) [
      "-DLLVM_ENABLE_PROJECTS=${lib.concatStringsSep ";" targetProjects}"
    ]
    ++
      lib.optionals ((finalAttrs.passthru.isLLVM || targetDir == "runtimes") && targetRuntimes != [ ])
        [
          "-DLLVM_ENABLE_RUNTIMES=${lib.concatStringsSep ";" targetRuntimes}"
        ]
    ++ lib.optionals finalAttrs.passthru.isLLVM [
      "-DLLVM_INSTALL_UTILS=ON"
      "-DLLVM_INSTALL_GTEST=ON"
    ]
    ++ lib.optionals (buildDocs || buildMan) [
      "-DLLVM_INCLUDE_DOCS=ON"
      "-DLLVM_BUILD_DOCS=ON"
      # "-DLLVM_ENABLE_DOXYGEN=ON" Way too slow, only uses one core
      "-DLLVM_ENABLE_SPHINX=ON"
      "-DSPHINX_OUTPUT_HTML=ON"
      "-DSPHINX_OUTPUT_MAN=ON"
      "-DSPHINX_WARNINGS_AS_ERRORS=OFF"
    ]
    ++ lib.optionals buildTests [
      "-DLLVM_INCLUDE_TESTS=ON"
      "-DLLVM_BUILD_TESTS=ON"
      "-DLLVM_EXTERNAL_LIT=${lit}/bin/.lit-wrapped"
    ]
    ++ extraCMakeFlags;

  prePatch = ''
    cd ../
    chmod -R u+w .
  '';

  postPatch =
    ''
      cd ${targetDir}
    ''
    + lib.optionalString finalAttrs.passthru.isLLVM ''
      patchShebangs lib/OffloadArch/make_generated_offload_arch_h.sh
    ''
    + lib.optionalString (buildTests && finalAttrs.passthru.isLLVM) ''
      # FileSystem permissions tests fail with various special bits
      rm test/tools/llvm-objcopy/ELF/mirror-permissions-unix.test
      rm unittests/Support/Path.cpp

      substituteInPlace unittests/Support/CMakeLists.txt \
        --replace-fail "Path.cpp" ""
    ''
    + extraPostPatch;

  doCheck = buildTests;
  checkTarget = lib.concatStringsSep " " checkTargets;

  postInstall =
    lib.optionalString buildMan ''
      mkdir -p $info
    ''
    + extraPostInstall;

  passthru = {
    isLLVM = targetDir == "llvm";
    isClang = targetDir == "clang" || builtins.elem "clang" targetProjects;

    updateScript = rocmUpdateScript {
      name = finalAttrs.pname;
      owner = finalAttrs.src.owner;
      repo = finalAttrs.src.repo;
    };
  };

  inherit hardeningDisable requiredSystemFeatures;

  meta = with lib; {
    description = "ROCm fork of the LLVM compiler infrastructure";
    homepage = "https://github.com/ROCm/llvm-project";
    license = with licenses; [ ncsa ] ++ extraLicenses;
    maintainers =
      with maintainers;
      [
        acowley
        lovesegfault
      ]
      ++ teams.rocm.members;
    platforms = platforms.linux;
    broken = isBroken || versionAtLeast finalAttrs.version "7.0.0";
  };
})
