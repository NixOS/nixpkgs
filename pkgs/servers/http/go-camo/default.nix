{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-camo";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "cactus";
    repo = pname;
    rev = "v${version}";
    sha256 = "1Wzy5EHFJAPnxusUBvNoJnXyVAx/LiiTgIQZE9r01Lw=";
  };

  vendorSha256 = "31B6LXCutIdPwxqMFTMUfxAaCuYW14py8Vu1EycBydE=";

  ldflags = [ "-s" "-w" "-X=main.ServerVersion=${version}" ];

  preCheck = ''
    # requires network access
    rm pkg/camo/proxy_{,filter_}test.go
  '';

  meta = with lib; {
    description = "A camo server is a special type of image proxy that proxies non-secure images over SSL/TLS";
    homepage = "https://github.com/cactus/go-camo";
    changelog = "https://github.com/cactus/go-camo/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ viraptor ];
  };
}
