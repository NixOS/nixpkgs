{ buildPythonPackage
, lib
, cmake
, pybind11
, zxing-cpp
, numpy
, pillow
}:

buildPythonPackage rec {
  pname = "zxing_cpp";
  inherit (zxing-cpp) src version;

  sourceRoot = "source/wrappers/python";
  patches = [
    ./use-nixpkgs-pybind11.patch
  ];
  dontUseCmakeConfigure = true;

  propagatedBuildInputs = [
    pybind11
    numpy
  ];

  nativeBuildInputs = [
    cmake
  ];

  nativeCheckInputs = [
    pillow
  ];

  meta = with lib; {
    homepage = "https://github.com/zxing-cpp/zxing-cpp";
    description = "Python bindings for C++ port of zxing (a Java barcode image processing library)";
    longDescription = ''
      ZXing-C++ ("zebra crossing") is an open-source, multi-format 1D/2D barcode
      image processing library implemented in C++.

      It was originally ported from the Java ZXing Library but has been
      developed further and now includes many improvements in terms of quality
      and performance. It can both read and write barcodes in a number of
      formats.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ lukegb ];
    platforms = with platforms; unix;
  };
}
