{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# build-system
, flit-core

# dependencies
, filetype
, defusedxml

# tests
, numpy
, opencv4
, pillow
, pytestCheckHook
, wand
}:

buildPythonPackage rec {
  pname = "willow";
  version = "1.6.2";
  format = "pyproject";

  disabled = pythonOlder "2.7";

  src = fetchFromGitHub {
    owner = "wagtail";
    repo = "Willow";
    rev = "refs/tags/v${version}";
    hash = "sha256-dW2FVN3/mBAhVQ094uBsnXzdyTRKgHUDx0SWLm3g374=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    filetype
    defusedxml
  ];

  passthru.optional-dependencies = {
    heif = [
      # TODO: pillow-heif
    ];
  };

  nativeCheckInputs = [
    numpy
    opencv4
    pytestCheckHook
    pillow
    wand
  ];

  disabledTests = [
    # pillow-heif missing
    "test_avif"
    "test_heic"
    "test_heif"
    "test_save_as_avif"
    "test_save_as_heif"
    "test_save_as_heic"
    "test_detect_faces"
  ];

  meta = with lib; {
    description = "A Python image library that sits on top of Pillow, Wand and OpenCV";
    homepage = "https://github.com/torchbox/Willow/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ desiderius ];
  };

}
