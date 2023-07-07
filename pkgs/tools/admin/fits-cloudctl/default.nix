{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "fits-cloudctl";
  version = "0.11.9";

  src = fetchFromGitHub {
    owner = "fi-ts";
    repo = "cloudctl";
    rev = "v${version}";
    sha256 = "sha256-OS/yEr3/HQTPCfonQABvHW+c5wSzhi8JbrMbfwuyd/s=";
  };

  vendorHash = "sha256-j/ZsnvcGREmFpO7IJfPVmSFkKSIJW+bAMqAGNj8vopk=";

  meta = with lib; {
    description = "Command-line client for FI-TS Finance Cloud Native services";
    homepage = "https://github.com/fi-ts/cloudctl";
    license = licenses.mit;
    maintainers = with maintainers; [ j0xaf ];
    mainProgram = "cloudctl";
  };
}
