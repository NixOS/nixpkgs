{ boto3, buildPythonPackage, crc32c, fetchFromGitHub, lib, matplotlib, moto
, numpy, pillow, pytorch, protobuf, six, pytestCheckHook
, tensorflow-tensorboard, torchvision }:

buildPythonPackage rec {
  pname = "tensorboardx";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "lanpa";
    repo = "tensorboardX";
    rev = "v${version}";
    sha256 = "0qqalq0fhbx0wnd8wdwhyhkkv2brvj9qbk3373vk3wjxbribf5c7";
  };

  checkInputs = [
    pytestCheckHook boto3 crc32c matplotlib moto pillow pytorch tensorflow-tensorboard torchvision
  ];

  propagatedBuildInputs = [ numpy protobuf six ];

  disabledTests = [ "test_TorchVis"  "test_onnx_graph" ];

  meta = with lib; {
    broken = true;
    description = "Library for writing tensorboard-compatible logs";
    homepage = "https://github.com/lanpa/tensorboardX";
    license = licenses.mit;
    maintainers = with maintainers; [ lebastr akamaus ];
    platforms = platforms.all;
  };
}
