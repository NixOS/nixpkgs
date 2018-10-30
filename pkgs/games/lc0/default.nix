{
  stdenv, fetchFromGitHub,
  meson, ninja, pkgconfig,
  zlib, ispc,
  protobuf, protobufc, gtest,
  useCUDA ? false, cudatoolkit ? null, cudnn ? null, symlinkJoin,
  useOpenCL ? false, opencl-headers ? null, ocl-icd ? null,
  useOpenBLAS ? false, openblas ? null
}:
let
  pname = "lc0";
  version = "0.18.1";
  optionals = stdenv.lib.optionals;
  buildBackends = useCUDA || useOpenBLAS || useOpenCL;

  cuda-combined = symlinkJoin {
    name = "cuda-combined";
    paths = [ cudatoolkit cudnn cudatoolkit.lib ];
  };
in

assert useCUDA -> cudatoolkit != null && cudnn != null;
assert (useOpenBLAS || useOpenCL) -> openblas != null;
assert useOpenCL -> opencl-headers != null && ocl-icd != null;

stdenv.mkDerivation {
  inherit pname version;
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "LeelaChessZero";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "05ipriwrm22zf3vkfibi45saji7aikgvfgw89lxs815k00qcv2fs";
  };

  nativeBuildInputs = [
    meson ninja pkgconfig
    zlib
    protobuf protobufc ispc gtest
    cudnn cudatoolkit
    openblas
    ocl-icd opencl-headers
  ];

  mesonFlags = [
    "-Dbuild_backends=${if buildBackends then "true" else "false"}"
  ] ++ optionals useCUDA [
    # Cuda needs cudalibdirs set to a merger of the two cuda packages. Broken for now.
    "-Dcuda=true"
    "-Dcudnn_libdirs=${cuda-combined}/lib"
    "-Dcudnn_include=${cuda-combined}/include"
  ] ++ optionals useOpenBLAS [
    "-Dblas=true"
  ] ++ optionals (useOpenCL || useOpenBLAS) [
    "-Dopenblas_libdirs=${openblas}/lib"
    "-Dopencl_include=${opencl-headers}/include"
  ] ++ optionals useOpenCL [
    "-Dopencl=true"
    "-Dopencl_libdirs=${ocl-icd}/lib"
  ];

  doCheck = gtest != null;
  checkPhase = ''
    for test in ./*_test
    do
      $test
    done
  '';

  meta = with stdenv.lib; {
    description = ''
      Lc0 is a UCI-compliant chess engine designed to play chess via neural
      network, specifically those of the LeelaChessZero project.
    '';
    homepage = https://lczero.org/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ synthetica ];
    platforms = platforms.linux;
    # You shouldn't really use the random-backend build, but it is possible.
    # cuDNN has to be updated before this works, 7.1.1 shoudl be enough.
    broken = (useCUDA && stdenv.lib.versionOlder cudnn.version "7.1.1") || !buildBackends;
  };
}
