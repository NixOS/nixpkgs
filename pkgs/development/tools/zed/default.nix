{ lib
, buildGoModule
, fetchFromGitHub
, testers
, zed
}:

buildGoModule rec {
  pname = "zed";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "brimdata";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1k5qw/uWe5gtDUjDcMW54ezoXOBLt4T9lRmiOS06hz8=";
  };

  vendorHash = "sha256-X1rE6/sgpB6jeTjLZJL/a7ghjRJYTXSQDHB4PmEFUmU=";

  subPackages = [ "cmd/zed" "cmd/zq" ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/brimdata/zed/cli.version=${version}"
  ];

  passthru.tests = {
    zed-version = testers.testVersion {
      package = zed;
    };
    zq-version = testers.testVersion {
      package = zed;
      command = "zq --version";
    };
  };

  meta = with lib; {
    description = "A novel data lake based on super-structured data";
    homepage = "https://zed.brimdata.io";
    changelog = "https://github.com/brimdata/zed/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dit7ya knl ];
  };
}
