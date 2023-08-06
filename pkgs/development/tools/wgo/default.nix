{ lib
, buildGoModule
, fetchFromGitHub
}:

let
  pname = "wgo";
  version = "0.5.1";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "bokwoon95";
    repo = "wgo";
    rev = "v${version}";
    hash = "sha256-kfa3Lm2oJomhoHbtSPLylRr+BFGV/y7xqSIv3xHHg3Q=";
  };

  vendorHash = "sha256-jxyO3MGrC+y/jJuwur/+tLIsbxGnT57ZXYzaf1lCv7A=";

  ldflags = [ "-s" "-w" ];

  subPackages = [ "." ];

  meta = with lib; {
    description = "Live reload for Go apps";
    homepage = "https://github.com/bokwoon95/wgo";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
