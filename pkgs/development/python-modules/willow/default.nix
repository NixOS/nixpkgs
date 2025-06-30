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
  version = "1.10.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "wagtail";
    repo = "Willow";
    tag = "v${version}";
    hash = "sha256-eJqrBopHsiI7jbM80x2lI5+aLSOPFuFZD/0fx6tLVnQ=";
  };

  build-system = [ flit-core ];

  pythonRelaxDeps = [ "defusedxml" ];

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
  ] ++ optional-dependencies.heif;

  disabledTests = [
    # ValueError: Invalid quality setting
    "test_save_avif_lossless"
  ];

  meta = with lib; {
    description = "Python image library that sits on top of Pillow, Wand and OpenCV";
    homepage = "https://github.com/torchbox/Willow/";
    changelog = "https://github.com/wagtail/Willow/releases/tag/${src.tag}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ desiderius ];
  };
}
