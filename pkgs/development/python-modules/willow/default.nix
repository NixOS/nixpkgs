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
  version = "1.9.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "wagtail";
    repo = "Willow";
    rev = "refs/tags/v${version}";
    hash = "sha256-H/UXE6gA6x849aqBcUgl3JYZ87OMNpuFyWGSsgqW1Rk=";
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

  meta = with lib; {
    description = "Python image library that sits on top of Pillow, Wand and OpenCV";
    homepage = "https://github.com/torchbox/Willow/";
    changelog = "https://github.com/wagtail/Willow/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ desiderius ];
  };
}
