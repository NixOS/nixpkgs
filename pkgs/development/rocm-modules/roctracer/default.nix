{
  lib,
  stdenv,
  fetchRocmMonorepoSource,
  rocmVersion,
  cmake,
  clr,
  rocm-device-libs,
  libxml2,
  doxygen,
  graphviz,
  gcc-unwrapped,
  libbacktrace,
  rocm-runtime,
  python3Packages,
  buildDocs ? false, # Nothing seems to be generated, so not making the output
  buildTests ? false,
}:

let
  source = rec {
    repo = "rocm-systems";
    version = rocmVersion;
    sourceSubdir = "projects/roctracer";
    hash = "sha256-KUNLX5ZonE0bW/xOacD3k3hCcg7M3Vk1dM3WQSDYMvM=";
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
stdenv.mkDerivation (finalAttrs: {
  pname = "roctracer";
  inherit (source) version src sourceRoot;

  outputs = [
    "out"
  ]
  ++ lib.optionals buildDocs [
    "doc"
  ]
  ++ lib.optionals buildTests [
    "test"
  ];

  nativeBuildInputs = [
    cmake
    clr
  ]
  ++ lib.optionals buildDocs [
    doxygen
    graphviz
  ];

  buildInputs = [
    libxml2
    libbacktrace
    python3Packages.python
    python3Packages.cppheaderparser
  ];

  cmakeFlags = [
    "-DCMAKE_MODULE_PATH=${clr}/hip/cmake"
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    # Needed with GCC 12
    "-Wno-error=array-bounds"
  ];

  postPatch = ''
    export HIP_DEVICE_LIB_PATH=${rocm-device-libs}/amdgcn/bitcode
  ''
  + lib.optionalString (!buildTests) ''
    substituteInPlace CMakeLists.txt \
      --replace "add_subdirectory(test)" ""
  '';

  # Tests always fail, probably need GPU
  # doCheck = buildTests;

  postInstall =
    lib.optionalString buildDocs ''
      mkdir -p $doc
    ''
    + lib.optionalString buildTests ''
      mkdir -p $test/bin
      # Not sure why this is an install target
      find $out/test -executable -type f -exec mv {} $test/bin \;
      rm $test/bin/{*.sh,*.py}
      patchelf --set-rpath $out/lib:${
        lib.makeLibraryPath (
          finalAttrs.buildInputs
          ++ [
            clr
            gcc-unwrapped.lib
            rocm-runtime
          ]
        )
      } $test/bin/*
      rm -rf $out/test
    '';

  meta = {
    inherit (source) homepage;
    description = "Tracer callback/activity library";
    license = with lib.licenses; [ mit ]; # mitx11
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
