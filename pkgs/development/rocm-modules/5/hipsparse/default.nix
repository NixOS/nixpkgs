{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, cmake
, rocm-cmake
, rocsparse
, clr
, gfortran
, git
, gtest
, openmp
, buildTests ? false
, buildSamples ? false
, gpuTargets ? [ ]
}:

# This can also use cuSPARSE as a backend instead of rocSPARSE
stdenv.mkDerivation (finalAttrs: {
  pname = "hipsparse";
  version = "5.7.1";

  outputs = [
    "out"
  ] ++ lib.optionals buildTests [
    "test"
  ] ++ lib.optionals buildSamples [
    "sample"
  ];

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "hipSPARSE";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-txigaOoZMI/v+EQLgGlj2O0IHfE7EpgjL0cyv49nKzo=";
  };

  nativeBuildInputs = [
    cmake
    rocm-cmake
    clr
    gfortran
  ];

  buildInputs = [
    rocsparse
    git
  ] ++ lib.optionals buildTests [
    gtest
  ] ++ lib.optionals (buildTests || buildSamples) [
    openmp
  ];

  cmakeFlags = [
    "-DCMAKE_C_COMPILER=hipcc"
    "-DCMAKE_CXX_COMPILER=hipcc"
    "-DBUILD_CLIENTS_SAMPLES=${if buildSamples then "ON" else "OFF"}"
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ] ++ lib.optionals (gpuTargets != [ ]) [
    "-DAMDGPU_TARGETS=${lib.concatStringsSep ";" gpuTargets}"
  ] ++ lib.optionals buildTests [
    "-DBUILD_CLIENTS_TESTS=ON"
  ];

  # We have to manually generate the matrices
  # CMAKE_MATRICES_DIR seems to be reset in clients/tests/CMakeLists.txt
  postPatch = lib.optionalString buildTests ''
    mkdir -p matrices

    ln -s ${rocsparse.passthru.matrices.matrix-01}/*.mtx matrices
    ln -s ${rocsparse.passthru.matrices.matrix-02}/*.mtx matrices
    ln -s ${rocsparse.passthru.matrices.matrix-03}/*.mtx matrices
    ln -s ${rocsparse.passthru.matrices.matrix-04}/*.mtx matrices
    ln -s ${rocsparse.passthru.matrices.matrix-05}/*.mtx matrices
    ln -s ${rocsparse.passthru.matrices.matrix-06}/*.mtx matrices
    ln -s ${rocsparse.passthru.matrices.matrix-07}/*.mtx matrices
    ln -s ${rocsparse.passthru.matrices.matrix-08}/*.mtx matrices
    ln -s ${rocsparse.passthru.matrices.matrix-09}/*.mtx matrices
    ln -s ${rocsparse.passthru.matrices.matrix-10}/*.mtx matrices
    ln -s ${rocsparse.passthru.matrices.matrix-11}/*.mtx matrices
    ln -s ${rocsparse.passthru.matrices.matrix-12}/*.mtx matrices
    ln -s ${rocsparse.passthru.matrices.matrix-13}/*.mtx matrices
    ln -s ${rocsparse.passthru.matrices.matrix-14}/*.mtx matrices
    ln -s ${rocsparse.passthru.matrices.matrix-15}/*.mtx matrices
    ln -s ${rocsparse.passthru.matrices.matrix-16}/*.mtx matrices
    ln -s ${rocsparse.passthru.matrices.matrix-17}/*.mtx matrices
    ln -s ${rocsparse.passthru.matrices.matrix-18}/*.mtx matrices
    ln -s ${rocsparse.passthru.matrices.matrix-19}/*.mtx matrices

    # Not used by the original cmake, causes an error
    rm matrices/*_b.mtx

    echo "deps/convert.cpp -> deps/mtx2csr"
    hipcc deps/convert.cpp -O3 -o deps/mtx2csr

    for mat in $(ls -1 matrices | cut -d "." -f 1); do
      echo "mtx2csr: $mat.mtx -> $mat.bin"
      deps/mtx2csr matrices/$mat.mtx matrices/$mat.bin
      unlink matrices/$mat.mtx
    done

    substituteInPlace clients/tests/CMakeLists.txt \
      --replace "\''${PROJECT_BINARY_DIR}/matrices" "/build/source/matrices"
  '';

  postInstall = lib.optionalString buildTests ''
    mkdir -p $test/bin
    mv $out/bin/hipsparse-test $test/bin
    mv /build/source/matrices $test
    rmdir $out/bin
  '' + lib.optionalString buildSamples ''
    mkdir -p $sample/bin
    mv clients/staging/example_* $sample/bin
    patchelf --set-rpath $out/lib:${lib.makeLibraryPath (
      finalAttrs.buildInputs ++ [ clr gfortran.cc ])} $sample/bin/example_*
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "ROCm SPARSE marshalling library";
    homepage = "https://github.com/ROCm/hipSPARSE";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
    broken = versions.minor finalAttrs.version != versions.minor stdenv.cc.version || versionAtLeast finalAttrs.version "6.0.0";
  };
})
