{ lib, config, stdenv, fetchFromGitHub, symlinkJoin, wrapGAppsHook, cmake, boost172
, pkg-config, flex, bison, libpng, libtiff, zlib, python3, embree, openexr
, openimagedenoise, openimageio_1, tbb, c-blosc, gtk3, pcre, doxygen
# OpenCL Support
, withOpenCL ? true, ocl-icd
# Cuda Support
, withCuda ? config.cudaSupport or false, cudatoolkit }:

let
  boostWithPython = boost172.override {
    enablePython = true;
    enableNumpy = true;
    python = python3;
  };

  # Requires a version number like "<MAJOR><MINOR>"
  pythonVersion = (lib.versions.major python3.version)
    + (lib.versions.minor python3.version);

in stdenv.mkDerivation rec {
  pname = "luxcorerender";
  version = "2.4";

  src = fetchFromGitHub {
    owner = "LuxCoreRender";
    repo = "LuxCore";
    rev = "luxcorerender_v${version}";
    sha256 = "0xvivw79719fa1q762b76nyvzawfd3hmp8y5j04bax8a7f8mfa9k";
  };

  nativeBuildInputs = [ pkg-config cmake flex bison doxygen wrapGAppsHook ];

  buildInputs = [
    libpng
    libtiff
    zlib
    boostWithPython.dev
    python3
    embree
    openexr
    openimagedenoise
    tbb
    c-blosc
    gtk3
    pcre
    openimageio_1.dev
    openimageio_1.out
  ] ++ lib.optionals withOpenCL [ ocl-icd ]
    ++ lib.optionals withCuda [ cudatoolkit ];

  cmakeFlags = [ "-DPYTHON_V=${pythonVersion}" ]
    ++ lib.optional (!withOpenCL) "-DLUXRAYS_DISABLE_OPENCL=1"
    ++ lib.optional (!withCuda) "-DLUXRAYS_DISABLE_CUDA=1";

  preConfigure = ''
    NIX_LDFLAGS+=" -lpython3"
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib
    cp -va bin/* $out/bin
    cp -va lib/* $out/lib
  '';

  meta = with lib; {
    description = "Open source, physically based, unbiased rendering engine";
    homepage = "https://luxcorerender.org/";
    maintainers = with maintainers; [ hodapp ];
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}

# TODO (might not be necessary):
#
# luxcoreui still gives warnings like: "failed to commit changes to
# dconf: GDBus.Error:org.freedesktop.DBus.Error.ServiceUnknown: The
# name ca.desrt.dconf was not provided by any .service files"

# CMake complains of the FindOpenGL/GLVND preference
