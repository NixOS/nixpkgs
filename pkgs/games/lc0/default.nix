{
  stdenv, fetchFromGitHub,
  meson, ninja, pkgconfig,
  zlib, ispc,
  protobuf, protobufc, gtest,
  buildBackends ? true,
  useCUDA ? false, cudatoolkit ? null, cudnn ? null,
  useOpenCL ? false, opencl-headers ? null, ocl-icd ? null,
  useOpenBLAS ? false, openblas ? null
}:
let
  pname = "lc0";
  version = "0.18.0-rc1";
  optionals = stdenv.lib.optionals;
in

assert buildBackends -> useCUDA || useOpenBLAS || useOpenCL;
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
    sha256 = "18m5hmhc770b0m1p2ni8pl4dy9q81120cjxz9sag25inwn5vybc0";
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
    "-Dcudnn_libdirs=${cudatoolkit}/lib"
  ] ++ optionals useOpenBLAS [
    "-Dblas=true"
  ] ++ optionals (useOpenCL || useOpenBLAS) [
    "-Dopenblas_libdirs=${openblas}/lib"
  ] ++ optionals useOpenCL [
    "-Dopencl=true"
    "-Dopencl_libdirs=${ocl-icd}/lib"
    "-Dopencl_include=${opencl-headers}/include"
  ];

  doCheck = gtest != null;
  checkPhase = ''
    for test in /build/source/build/*_test
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
    broken = useCUDA;
  };
}
