{
  lib,
  buildPythonPackage,
  defusedxml,
  fetchFromGitHub,
  filetype,
  flit-core,
  numpy,
  opencv4,
  pillow-heif,
  pillow,
  pytestCheckHook,
  pythonOlder,
  wand,
}:

buildPythonPackage rec {
  pname = "willow";
  version = "1.11.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "wagtail";
    repo = "Willow";
    tag = "v${version}";
    hash = "sha256-7aVLPSspwQRWQ+aNYbKkOBzwc7uoVzQvAG8vezp8QZY=";
  };

  build-system = [ flit-core ];

  dependencies = [
    filetype
    defusedxml
  ];

  optional-dependencies = {
    heif = [ pillow-heif ];
  };

  nativeCheckInputs = [
    numpy
    opencv4
    pytestCheckHook
    pillow
    wand
  ]
  ++ optional-dependencies.heif;

  meta = {
    description = "Python image library that sits on top of Pillow, Wand and OpenCV";
    homepage = "https://github.com/torchbox/Willow/";
    changelog = "https://github.com/wagtail/Willow/releases/tag/v${version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      kuflierl
    ];
  };
}
