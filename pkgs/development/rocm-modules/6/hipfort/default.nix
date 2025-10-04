{
  lib,
  stdenv,
  fetchpatch,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
  rocm-cmake,
  gfortran,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hipfort";
  version = "6.4.3";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "hipfort";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-Nks1+0X8bLtZ9HqZXJOtrAWQlJquMH+feuu1stf/9Vo=";
  };

  patches = [
    (fetchpatch {
      name = "hipfort-fix-cmake-4.patch";
      url = "https://github.com/ROCm/hipfort/commit/75552c7ec48e3bd6a914c57c9475ec573ccb37d9.patch";
      hash = "sha256-S9r1V6cUo9QbKbu/NK4wIvXMV6BFv7+/n9mjCScVk40=";
      includes = [ "bin/*" ];
    })
  ];

  nativeBuildInputs = [
    cmake
    rocm-cmake
    gfortran
  ];

  cmakeFlags = [
    "-DHIPFORT_COMPILER=${gfortran}/bin/gfortran"
    "-DHIPFORT_AR=${gfortran.cc}/bin/gcc-ar"
    "-DHIPFORT_RANLIB=${gfortran.cc}/bin/gcc-ranlib"
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ];

  postPatch = ''
    patchShebangs bin

    substituteInPlace bin/hipfc bin/mymcpu \
      --replace "/bin/cat" "cat"

    substituteInPlace bin/CMakeLists.txt \
      --replace "/bin/mkdir" "mkdir" \
      --replace "/bin/cp" "cp" \
      --replace "/bin/sed" "sed" \
      --replace "/bin/chmod" "chmod" \
      --replace "/bin/ln" "ln"
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    inherit (finalAttrs.src) owner;
    inherit (finalAttrs.src) repo;
  };

  meta = with lib; {
    description = "Fortran interfaces for ROCm libraries";
    homepage = "https://github.com/ROCm/hipfort";
    license = with licenses; [ mit ]; # mitx11
    teams = [ teams.rocm ];
    platforms = platforms.linux;
  };
})
