{ buildPythonPackage
, fetchPypi
, lib

# build dependencies
, cython
, leptonica
, pkg-config
, tesseract4

# propagates
, pillow

# tests
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "tesserocr";
<<<<<<< HEAD
  version = "2.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-pz82cutgQ9ifMS6+40mcBiOsXIqeEquYdBWT+npZNPY=";
=======
  version = "2.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-d0MNJytT2s073Ur11WP9wkrlG4b9vJzy6BRvKceryaQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # https://github.com/sirfz/tesserocr/issues/314
  postPatch = ''
    sed -i '/allheaders.h/a\    pass\n\ncdef extern from "leptonica/pix_internal.h" nogil:' tesseract.pxd
  '';

  nativeBuildInputs = [
    cython
    pkg-config
  ];

  buildInputs = [
    leptonica
    tesseract4
  ];

  propagatedBuildInputs = [
    pillow
  ];

  pythonImportsCheck = [
    "tesserocr"
  ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/sirfz/tesserocr/releases/tag/v${version}";
    description = "A simple, Pillow-friendly, wrapper around the tesseract-ocr API for Optical Character Recognition (OCR)";
    homepage = "https://github.com/sirfz/tesserocr";
    license = licenses.mit;
    maintainers = with maintainers; [ mtrsk ];
    platforms = platforms.linux;
  };
}
