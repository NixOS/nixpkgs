{ buildPythonPackage
, fetchFromGitHub
, lib
, pytestCheckHook
, torch
, torchvision
, pyyaml
, huggingface-hub
, expecttest
}: buildPythonPackage rec {
  pname = "timm";
  version = "0.6.11";
  src = fetchFromGitHub {
    owner = "rwightman";
    repo = "pytorch-image-models";
    rev = "v${version}";
    hash = "sha256-wtxqK4VsBK2456UI6AXDAeCJTvylNPUc81SPL5xA6NI=";
  };

  propagatedBuildInputs = [ torch torchvision pyyaml huggingface-hub ];

  # Takes a really long time to run
  doCheck = false;

  checkInputs = [ pytestCheckHook expecttest ];

  meta = with lib; {
    description = ''
      PyTorch image models, scripts, pretrained
      weights -- ResNet, ResNeXT, EfficientNet,
      EfficientNetV2, NFNet, Vision Transformer,
      MixNet, MobileNet-V3/V2, RegNet, DPN, CSPNet,
      and more
    '';
    homepage = "https://github.com/rwightman/pytorch-image-models";
    license = licenses.asl20;
    maintainers = with maintainers; [ ehllie ];
  };
}
