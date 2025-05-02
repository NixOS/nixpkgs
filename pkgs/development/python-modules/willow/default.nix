{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# build-system
, flit-core

# dependencies
, filetype
, defusedxml

# optional-dependencies
, pillow-heif

# tests
, numpy
, opencv4
, pillow
, pytestCheckHook
, wand
}:

buildPythonPackage rec {
  pname = "willow";
  version = "1.8.0";
  format = "pyproject";

  disabled = pythonOlder "2.7";

  src = fetchFromGitHub {
    owner = "wagtail";
    repo = "Willow";
    rev = "refs/tags/v${version}";
    hash = "sha256-g9/v56mdo0sJe5Pl/to/R/kXayaKK3qaYbnnPXpFjXE=";
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
      pillow-heif
    ];
  };

  nativeCheckInputs = [
    numpy
    opencv4
    pytestCheckHook
    pillow
    wand
  ] ++ passthru.optional-dependencies.heif;

  meta = with lib; {
    description = "A Python image library that sits on top of Pillow, Wand and OpenCV";
    homepage = "https://github.com/torchbox/Willow/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ desiderius ];
  };

}
