{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gore";
  version = "0.5.6";

  src = fetchFromGitHub {
    owner = "motemen";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Z2WOgkgi/JK/s0961FvgboJwYtxbFdRSzzPiE74SVaY=";
  };

  vendorHash = "sha256-1ftO+Bjc+vqB/azn4K6iRNrCLrz+QjpPzNfja3yvOrs=";

  doCheck = false;

  meta = with lib; {
    description = "Yet another Go REPL that works nicely";
    homepage = "https://github.com/motemen/gore";
    license = licenses.mit;
    maintainers = with maintainers; [ offline ];
  };
}
