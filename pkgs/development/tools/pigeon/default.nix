{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pigeon";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "mna";
    repo = "pigeon";
    rev = "v${version}";
    sha256 = "sha256-/am9ZcGmWeHub6WWHdXuZH4A/vx/F3nh6kjTp48msY8=";
  };

  vendorHash = "sha256-5zfgc94YN8mq6S+Ms3wDTO2Q2oWa3iTtN6eSnp0BY1Y=";

  proxyVendor = true;

  subPackages = [ "." ];

  doCheck = false;

  meta = {
    homepage = "https://github.com/mna/pigeon";
    description = "PEG parser generator for Go";
    mainProgram = "pigeon";
    maintainers = with lib.maintainers; [ zimbatm ];
    license = with lib.licenses; [ bsd3 ];
  };
}
