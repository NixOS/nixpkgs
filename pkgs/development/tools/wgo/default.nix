{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "wgo";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "bokwoon95";
    repo = "wgo";
    rev = "v${version}";
    hash = "sha256-kfa3Lm2oJomhoHbtSPLylRr+BFGV/y7xqSIv3xHHg3Q=";
  };

  vendorSha256 = "sha256-jxyO3MGrC+y/jJuwur/+tLIsbxGnT57ZXYzaf1lCv7A=";

  ldflags = [ "-s" "-w" ];

  subPackages = [ "." ];

  meta = with lib; {
    description = "Live reload for Go apps";
    homepage = "https://github.com/bokwoon95/wgo";
    license = licenses.mit;
    maintainers = with maintainers; [ bokwoon95 ];
  };
}

