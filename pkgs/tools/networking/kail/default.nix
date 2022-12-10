{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kail";
  version = "0.15.0";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  src = fetchFromGitHub {
    owner = "boz";
    repo = "kail";
    rev = "v${version}";
    sha256 = "0b4abzk8lc5qa04ywkl8b5hb9jmxhyi2dpgbl27gmw81525wjnj7";
  };

  vendorSha256 = "09s7sq23hglcb2rsi9igzql39zs4238f3jfmvxz9a8v41da225np";

  meta = with lib; {
    description = "Kubernetes log viewer";
    homepage = "https://github.com/boz/kail";
    license = licenses.mit;
    maintainers = with maintainers; [ offline vdemeester ];
  };
}
