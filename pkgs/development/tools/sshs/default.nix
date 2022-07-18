{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
}:

buildGoModule rec {
  pname = "sshs";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "quantumsheep";
    repo = pname;
    rev = version;
    sha256 = "D9doNVb2sTnzM8tF8cSJbIoaIYjGurkUHEyhcE3OqQg=";
  };

  vendorSha256 = "QWFz85bOrTnPGum5atccB5hKeATlZvDAt32by+DO/Fo=";

  ldflags = [ "-s" "-w" "-X github.com/quantumsheep/sshs/cmd.Version=${version}" ];

  passthru.updateScript = nix-update-script {
    attrPath = pname;
  };

  meta = with lib; {
    description = "Terminal user interface for SSH";
    homepage = "https://github.com/quantumsheep/sshs";
    license = licenses.mit;
    maintainers = with maintainers; [ ihatethefrench ];
  };
}
