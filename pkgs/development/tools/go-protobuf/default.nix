{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-protobuf";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "protobuf";
    rev = "v${version}";
    sha256 = "sha256-cRB4oicBfYvhqtzafWWmf82AuvSnB0NhHwpp0pjgwQ0=";
  };

  vendorHash = "sha256-CcJjFMslSUiZMM0LLMM3BR53YMxyWk8m7hxjMI9tduE=";

  meta = with lib; {
    homepage    = "https://github.com/golang/protobuf";
    description = " Go bindings for protocol buffer";
    maintainers = with maintainers; [ lewo ];
    license     = licenses.bsd3;
  };
}
