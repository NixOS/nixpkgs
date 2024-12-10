{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  ghz,
}:

buildGoModule rec {
  pname = "ghz";
  version = "0.118.0";

  src = fetchFromGitHub {
    owner = "bojand";
    repo = "ghz";
    rev = "v${version}";
    sha256 = "sha256-oBxkXe5PHdi5H5qSwV2G6+wBTvI4nRJuaRnUiq/3l+c=";
  };

  vendorHash = "sha256-h/obb+hJ0XnE7GK7G5djITjiL0OjjIk1q68JM8+EfHo=";

  subPackages = [
    "cmd/ghz"
    "cmd/ghz-web"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = ghz;
    };
    web-version = testers.testVersion {
      package = ghz;
      command = "ghz-web -v";
    };
  };

  meta = with lib; {
    description = "Simple gRPC benchmarking and load testing tool";
    homepage = "https://ghz.sh";
    license = licenses.asl20;
  };
}
