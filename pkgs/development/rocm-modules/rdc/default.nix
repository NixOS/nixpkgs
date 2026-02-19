{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
  pkg-config,
  amdsmi,
  rocm-smi,
  rocm-runtime,
  libcap,
  libdrm,
  grpc,
  protobuf,
  openssl,
  doxygen,
  graphviz,
  texliveSmall,
  gtest,
  buildDocs ? true,
  buildTests ? false,
}:

let
  latex = lib.optionalAttrs buildDocs (
    texliveSmall.withPackages (
      ps: with ps; [
        changepage
        latexmk
        varwidth
        multirow
        hanging
        adjustbox
        collectbox
        stackengine
        enumitem
        alphalph
        wasysym
        sectsty
        tocloft
        newunicodechar
        etoc
        helvetic
        wasy
        courier
      ]
    )
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "rdc";
  version = "7.1.1";

  outputs = [
    "out"
  ]
  ++ lib.optionals buildDocs [
    "doc"
  ]
  ++ lib.optionals buildTests [
    "test"
  ];

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rdc";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-oJS0fBeISpgjZkaMfFl/Yq7mPOsdaZDqiRjSPv7kT1Q=";
  };

  patches = [
    # https://github.com/ROCm/rocm-systems/pull/2423
    ./fix-cmake-cxxflags.patch
    # https://github.com/ROCm/rocm-systems/pull/2424
    ./fix-libcap-pkgconfig.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    protobuf
  ]
  ++ lib.optionals buildDocs [
    doxygen
    graphviz
    latex
  ];

  buildInputs = [
    amdsmi
    rocm-smi
    rocm-runtime
    libcap
    libdrm
    grpc
    openssl
  ]
  ++ lib.optionals buildTests [
    gtest
  ];

  cmakeFlags = [
    "-DCMAKE_VERBOSE_MAKEFILE=ON"
    "-DRDC_INSTALL_PREFIX=${placeholder "out"}"
    "-DBUILD_RVS=OFF" # TODO: Needs RVS package
    "-DBUILD_ROCRTEST=ON"
    "-DRSMI_INC_DIR=${rocm-smi}/include"
    "-DRSMI_LIB_DIR=${rocm-smi}/lib"
    "-DGRPC_ROOT=${grpc}"
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBEXECDIR=libexec"
    "-DCMAKE_INSTALL_DOCDIR=doc"
  ]
  ++ lib.optionals buildTests [
    "-DBUILD_TESTS=ON"
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "file(STRINGS /etc/os-release LINUX_DISTRO LIMIT_COUNT 1 REGEX \"NAME=\")" "set(LINUX_DISTRO \"NixOS\")"
  '';

  postInstall = ''
    find $out/bin -executable -type f -exec \
      patchelf {} --shrink-rpath --allowed-rpath-prefixes "$NIX_STORE" \;
  ''
  + lib.optionalString buildTests ''
    mkdir -p $test
    mv $out/bin/rdctst_tests $test/bin
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    inherit (finalAttrs.src) owner;
    inherit (finalAttrs.src) repo;
  };

  meta = {
    description = "Simplifies administration and addresses infrastructure challenges in cluster and datacenter environments";
    homepage = "https://github.com/ROCm/rdc";
    license = with lib.licenses; [ mit ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
