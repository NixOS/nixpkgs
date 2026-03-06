{
  lib,
  buildPythonPackage,
  defusedxml,
  fetchFromGitHub,
  filetype,
  flit-core,
  opencv4,
  pillow-heif,
  pillow,
  pytestCheckHook,
  wand,
}:

buildPythonPackage rec {
  pname = "willow";
  version = "1.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wagtail";
    repo = "Willow";
    tag = "v${version}";
    hash = "sha256-vboQwOEDRdbwmLT2EW1iF98ZuyzEzlrP2k2ZcvVKjFE=";
  };

  build-system = [ flit-core ];

  dependencies = [
    filetype
    defusedxml
  ];

  optional-dependencies = {
    wand = [ wand ];
    pillow = [ pillow ];
    heif = [ pillow-heif ];
  };

  nativeCheckInputs = [
    opencv4
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

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
