{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "mubeng";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "kitabisa";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-z81/WbqhMJPliT5rrW4UY8gseV7R2UDQIUOjZuUgLTI=";
  };

  vendorSha256 = "sha256-CjAFntwpHvUOaaLHDOT9Dctptv5EFW62X8XWT4SvT2A=";

  ldflags = [ "-s" "-w" "-X ktbs.dev/mubeng/common.Version=${version}" ];

  meta = with lib; {
    description = "Proxy checker and IP rotator";
    homepage = "https://github.com/kitabisa/mubeng";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
