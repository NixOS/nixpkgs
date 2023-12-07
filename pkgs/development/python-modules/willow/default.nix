{ lib
, buildPythonPackage
, defusedxml
, fetchFromGitHub
, filetype
, flit-core
, numpy
, opencv4
, pillow
, pillow-heif
, pytestCheckHook
, pythonOlder
, wand
}:

buildPythonPackage rec {
  pname = "willow";
  version = "1.7.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "wagtail";
    repo = "Willow";
    rev = "refs/tags/v${version}";
    hash = "sha256-+ubylc/Zuw3DSSgtTg2dO3Zj0gpTJcLbb1J++caxS7w=";
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
    pillow = [
      pillow
    ];
    wand = [
      wand
    ];
  };

  nativeCheckInputs = [
    numpy
    opencv4
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [
    "willow"
  ];

  meta = with lib; {
    description = "A Python image library that sits on top of Pillow, Wand and OpenCV";
    homepage = "https://github.com/torchbox/Willow/";
    changelog = "https://github.com/wagtail/Willow/blob/v${version}/docs/changelog.rst";
    license = licenses.bsd2;
    maintainers = with maintainers; [ desiderius ];
  };

}
