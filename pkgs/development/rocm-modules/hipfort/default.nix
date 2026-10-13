{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
  rocm-cmake,
  gfortran,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hipfort";
  version = "7.2.3";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "hipfort";
    tag = "rocm-${finalAttrs.version}";
    hash = "sha256-XaB4jauCN41tgD1YHHA2td/yckwfMBemBe/iL0SCxQo=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gfortran
  ];

  buildInputs = [
    rocm-cmake
  ];

  cmakeFlags = [
    (lib.cmakeFeature "HIPFORT_COMPILER" "${gfortran}/bin/gfortran")
    (lib.cmakeFeature "HIPFORT_AR" "${gfortran.cc}/bin/gcc-ar")
    (lib.cmakeFeature "HIPFORT_RANLIB" "${gfortran.cc}/bin/gcc-ranlib")
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    (lib.cmakeFeature "CMAKE_INSTALL_BINDIR" "bin")
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
    (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "include")
  ];

  postPatch = ''
    patchShebangs bin

    substituteInPlace bin/hipfc bin/mymcpu \
      --replace-fail "/bin/cat" "cat"

    substituteInPlace bin/CMakeLists.txt \
      --replace-fail "/bin/mkdir" "mkdir" \
      --replace-fail "/bin/cp" "cp" \
      --replace-fail "/bin/sed" "sed" \
      --replace-fail "/bin/chmod" "chmod" \
      --replace-fail "/bin/ln" "ln"
  '';

  passthru.updateScript = rocmUpdateScript { inherit finalAttrs; };

  meta = {
    description = "Fortran interfaces for ROCm libraries";
    homepage = "https://github.com/ROCm/hipfort";
    changelog = "https://github.com/ROCm/hipfort/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit; # mitx11
    mainProgram = "hipfc";
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
