{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "reflex";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "cespare";
    repo = "reflex";
    rev = "v${version}";
    sha256 = "sha256-/2qVm2xpSFVspA16rkiIw/qckxzXQp/1EGOl0f9KljY=";
  };

  vendorSha256 = "sha256-JCtVYDHbhH2i7tGNK1jvgHCjU6gMMkNhQ2ZnlTeqtmA=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "A small tool to watch a directory and rerun a command when certain files change";
    homepage = "https://github.com/cespare/reflex";
    license = licenses.mit;
    maintainers = with maintainers; [ nicknovitski ];
  };
}
